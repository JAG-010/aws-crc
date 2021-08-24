# terraform {
#   backend "s3" {
#     bucket = "terraform-aws-crc"
#     key    = "crc/tfstate/terraform.tfstate"
#     region = "us-east-2"
#   }
# }


terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.26.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.0.1"
    }
  }
  required_version = ">= 0.14"

  backend "remote" {
    organization = "jag010"

    workspaces {
      name = "gh-actions"
    }
  }
}

module "s3-website" {
  source      = "./modules/s3-website"
  domain_name = var.site_name
  # webpath     = "/Users/jag/Documents/CloudResumeChallenge/aws-crc/HTML-Webpage"
  webpath = "./HTML-Webpage"
}


# output "website_endpoint" {
#   value = aws_s3_bucket.crc_web.website_endpoint
# }
