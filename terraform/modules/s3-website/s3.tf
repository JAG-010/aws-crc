

resource "aws_s3_bucket" "crc_web" {
  bucket = var.domain_name
  acl    = "public-read"

  website {
    index_document = "index.html"
    error_document = "error.html"
  }
  policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "PublicReadForGetBucketObjects",
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::${var.domain_name}/*"
    }
  ]
}
EOF
  provisioner "local-exec" {
    command = "aws s3 sync ${var.webpath} s3://${aws_s3_bucket.crc_web.id}"
  }
  tags = local.tags
}

# output "website_endpoint" {
#   value = aws_s3_bucket.crc_web.website_endpoint
# }