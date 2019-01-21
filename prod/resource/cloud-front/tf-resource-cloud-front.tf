provider "aws" {
  region = "us-east-1"
}
variable "appName" {
  type = "string"
}
variable "env" {
  type = "string"
}
variable "bucketName" {
  type = "string"
}
variable "bucketDomainName" {
  type = "string"
}
locals {
  s3_origin_id = "S3-${var.bucketName}"
}

resource "aws_cloudfront_distribution" "cfront_s3_dist_front" {
  origin {
    domain_name = "${var.bucketDomainName}"
    origin_id   = "${local.s3_origin_id}"
  }
  enabled             = false
  is_ipv6_enabled     = true
  price_class = "PriceClass_All"

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${local.s3_origin_id}"
    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 31536000
    
    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Application = "${var.appName}"
    Env         = "${var.env}"
  }

}