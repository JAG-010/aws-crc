data "archive_file" "pyzip" {
  type        = "zip"
  source_file = "py_scripts/lambda4dynamodb.py"
  output_path = "py_scripts/lambda4dynamodb.zip"
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_lambda_function" "lambda_py" {
  filename      = "py_scripts/lambda4dynamodb.zip"
  function_name = "crc_py_lambda"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "lambda4dynamodb.lambda_handler"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  #   source_code_hash = filebase64sha256("py_scripts/lambda4dynamodb.zip")

  runtime = "python3.8"

  tags = local.tags
  depends_on = [
    data.archive_file.pyzip
  ]

  #   environment {
  #     variables = {
  #       foo = "bar"
  #     }
  #   }
}