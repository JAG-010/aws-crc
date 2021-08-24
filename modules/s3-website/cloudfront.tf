locals {
  s3_origin_id = aws_s3_bucket.crc_web.id
}
data "aws_acm_certificate" "cert_name" {
  domain   = var.site_name
  statuses = ["ISSUED"]
}

resource "aws_cloudfront_distribution" "cdn" {
  depends_on = [
    aws_s3_bucket.crc_web
  ]
  origin {
    domain_name = aws_s3_bucket.crc_web.bucket_regional_domain_name
    origin_id   = local.s3_origin_id
    # s3_origin_config {
    #   origin_access_identity = aws_cloudfront_origin_access_identity.default.cloudfront_access_identity_path
    # }
  }


  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Some comment"
  default_root_object = "index.html"


  aliases = ["jagan-sekaran.me"]
  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  # Cache behavior with precedence 0
  ordered_cache_behavior {
    path_pattern     = "/content/immutable/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false
      headers      = ["Origin"]

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  # Cache behavior with precedence 1
  ordered_cache_behavior {
    path_pattern     = "/content/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  price_class = "PriceClass_200"

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US", "CA", "GB", "DE"]
    }
  }

  tags = local.tags

  viewer_certificate {
    acm_certificate_arn = data.aws_acm_certificate.cert_name.arn
    ssl_support_method  = "sni-only"
  }
}

# output "cf_id" {
#   value = aws_cloudfront_distribution.cdn.id
# }

resource "local_file" "cf_if" {
  content  = aws_cloudfront_distribution.cdn.id
  filename = "cf_id.txt"
}
