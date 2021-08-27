resource "aws_api_gateway_rest_api" "crc_api" {
  name        = "crc_api"
  description = "API to get data from DynamoDB via Lambda"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
  tags = local.tags
}


resource "aws_api_gateway_resource" "crc_api" {
  parent_id   = aws_api_gateway_rest_api.crc_api.root_resource_id
  path_part   = "crc_api"
  rest_api_id = aws_api_gateway_rest_api.crc_api.id
}

# module "cors" {
#   source = "squidfunk/api-gateway-enable-cors/aws"
#   version = "0.3.3"
#   api_id          = aws_api_gateway_rest_api.crc_api.id
#   api_resource_id = aws_api_gateway_resource.crc_api.id
# }

resource "aws_api_gateway_method" "crc_api" {
  authorization = "NONE"
  http_method   = "GET"
  resource_id   = aws_api_gateway_resource.crc_api.id
  rest_api_id   = aws_api_gateway_rest_api.crc_api.id
}

resource "aws_api_gateway_integration" "crc_api" {
  http_method             = aws_api_gateway_method.crc_api.http_method
  resource_id             = aws_api_gateway_resource.crc_api.id
  rest_api_id             = aws_api_gateway_rest_api.crc_api.id
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_py.invoke_arn
}

resource "aws_api_gateway_method_response" "response_200" {
  depends_on = [
    aws_api_gateway_method.crc_api
  ]
  rest_api_id = aws_api_gateway_rest_api.crc_api.id
  resource_id = aws_api_gateway_resource.crc_api.id
  http_method = aws_api_gateway_method.crc_api.http_method
  status_code = "200"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Headers" = true
  }
  response_models = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_integration_response" "cors" {
  depends_on  = [aws_api_gateway_integration.crc_api, aws_api_gateway_method_response.response_200]
  rest_api_id = aws_api_gateway_rest_api.crc_api.id
  resource_id = aws_api_gateway_resource.crc_api.id
  http_method = aws_api_gateway_method.crc_api.http_method
  status_code = 200
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = "'*'", # replace with hostname of frontend (CloudFront)
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET, POST'" # remove or add HTTP methods as needed
  }
}

resource "aws_api_gateway_deployment" "crc_api" {
  rest_api_id = aws_api_gateway_rest_api.crc_api.id

  triggers = {
    # NOTE: The configuration below will satisfy ordering considerations,
    #       but not pick up all future REST API changes. More advanced patterns
    #       are possible, such as using the filesha1() function against the
    #       Terraform configuration file(s) or removing the .id references to
    #       calculate a hash against whole resources. Be aware that using whole
    #       resources will show a difference after the initial implementation.
    #       It will stabilize to only change when resources change afterwards.
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.crc_api.id,
      aws_api_gateway_method.crc_api.id,
      aws_api_gateway_integration.crc_api.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "crc_api" {
  deployment_id = aws_api_gateway_deployment.crc_api.id
  rest_api_id   = aws_api_gateway_rest_api.crc_api.id
  stage_name    = "crc_api"
}