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

resource "aws_acm_certificate_validation" "acm_validate" {
  certificate_arn         = aws_acm_certificate.cert_acm.arn
  validation_record_fqdns = [for record in aws_route53_record.r53record : record.fqdn]

  depends_on = [
    aws_route53_record.r53record
  ]
}
