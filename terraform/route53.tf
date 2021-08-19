// Create Hosted zone on Route 53
resource "aws_route53_zone" "primary_hz" {
  name    = var.site_name
  tags    = local.tags
  comment = "Create Hosted zone for jagan-sekaran.me"
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

  depends_on = [
    aws_acm_certificate.cert_acm
  ]
}

data "aws_cloudfront_distribution" "cdn_data" {
  id = file("cf_id.txt")
  # tags = {
  #   Name = "aws-crc"
  # }
}

resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.r53data.zone_id
  name    = var.site_name
  type    = "A"
  # ttl     = "60"

  alias {
    name                   = data.aws_cloudfront_distribution.cdn_data.domain_name
    zone_id                = data.aws_cloudfront_distribution.cdn_data.hosted_zone_id
    evaluate_target_health = true
  }
}
