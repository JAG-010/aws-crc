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
