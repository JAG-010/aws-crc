# resource "aws_cloudfront_distribution" "cdn" {
#     origin {
#       domain_name = aws_s3_bucket.crc_web.bucket_regional_domain_name
#       origin_id = ?
#     }

#     enabled             = true
#     is_ipv6_enabled     = true
#     comment             = "Some comment"
#     default_root_object = "index.html"

#     aliases = ["jagan-sekaran.me"]
# }
