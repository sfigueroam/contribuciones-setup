variable "prefix" {
  type        = "string"
}
variable "appName" {
  type        = "string"
}
variable "env" {
  type        = "string"
}

resource "aws_s3_bucket" "s3_bucket_front" {
  bucket  = "${var.prefix}-front"
  acl     = "private"
  versioning {
    enabled = false
  }
  website {
    index_document = "index.html"
    error_document = "error.html"
  }
  tags = {
    Application = "${var.appName}"
	  Env         = "${var.env}"
  }
}

resource "aws_s3_bucket" "s3_bucket_direcciones" {
  bucket  = "${var.prefix}-direcciones"
  acl     = "private"
  versioning {
    enabled = false
  }
  tags = {
    Application = "${var.appName}"
	  Env         = "${var.env}"
  }
}

resource "aws_s3_bucket" "s3_bucket_parse" {
  bucket  = "${var.prefix}-parse"
  acl     = "private"
  versioning {
    enabled = false
  }
  tags = {
    Application = "${var.appName}"
	  Env         = "${var.env}"
  }
}

resource "aws_s3_bucket" "s3_bucket_token" {
  bucket  = "${var.prefix}-token"
  acl     = "private"
  versioning {
    enabled = false
  }
  tags = {
    Application = "${var.appName}"
	  Env         = "${var.env}"
  }
}

output "out_s3_bucket_parse_name" {
  value = "${aws_s3_bucket.s3_bucket_parse.id}"
}
output "out_s3_bucket_token_name" {
  value = "${aws_s3_bucket.s3_bucket_token.id}"
}
output "out_s3_bucket_front_domain_name" {
  value = "${aws_s3_bucket.s3_bucket_front.bucket_domain_name}"
}