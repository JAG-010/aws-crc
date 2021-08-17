terraform {
  backend "s3" {
    bucket = "terraform-aws-crc"
    key    = "crc/tfstate/terraform.tfstate"
    region = "us-east-2"
  }
}


module "s3-website" {
  source      = "./modules/s3-website"
  domain_name = var.site_name
  webpath     = "/Users/jag/Documents/CloudResumeChallenge/aws-crc/HTML-Webpage"
}

// Create Hosted zone on Route 53
resource "aws_route53_zone" "primary_hz" {
  name    = var.site_name
  tags    = local.tags
  comment = "Create Hosted zone for jagan-sekaran.me"
}

// Create certificate 
resource "aws_acm_certificate" "cert_acm" {
  # provider = aws.us-east-1
  domain_name       = var.site_name
  validation_method = "DNS"

  tags = local.tags

  lifecycle {
    create_before_destroy = true
  }
}

// Certificate validation - DNS
data "aws_route53_zone" "r53data" {
  name         = var.site_name
  private_zone = false
  depends_on = [
    aws_route53_zone.primary_hz
  ]
}

resource "aws_route53_record" "r53record" {
  for_each = {
    for dvo in aws_acm_certificate.cert_acm.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.r53data.zone_id
}


resource "aws_acm_certificate_validation" "acm_validate" {
  certificate_arn         = aws_acm_certificate.cert_acm.arn
  validation_record_fqdns = [for record in aws_route53_record.r53record : record.fqdn]
}
# output "website_endpoint" {
#   value = aws_s3_bucket.crc_web.website_endpoint
# }
