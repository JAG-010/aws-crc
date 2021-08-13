variable "aws_region" {
  type    = string
  default = "us-east-2"
}

variable "domain_name" {
  description = "This is the bucket name"
  type        = string
}

variable "webpath" {
  type = string
}