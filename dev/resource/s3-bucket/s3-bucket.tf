variable "appPrefix" {
  type = "string"
}
variable "appName" {
  type = "string"
}
variable "env" {
  type = "string"
}

resource "aws_s3_bucket" "s3_bucket_front" {
  bucket = "${var.appPrefix}-front"
  acl = "public-read"
  versioning {
    enabled = false
  }
  website {
    index_document = "index.html"
    error_document = "error.html"
  }
  tags = {
    Application = "${var.appName}"
    Env = "${var.env}"
  }
}

/*
resource "aws_s3_bucket" "s3_bucket_direcciones" {
  bucket = "${var.appPrefix}-direcciones-esloader"
  acl = "private"
  versioning {
    enabled = false
  }
  tags = {
    Application = "${var.appName}"
    Env = "${var.env}"
  }
}
*/

resource "aws_s3_bucket" "s3_bucket_parse" {
  bucket = "${var.appPrefix}-parse"
  acl = "private"
  versioning {
    enabled = false
  }
  tags = {
    Application = "${var.appName}"
    Env = "${var.env}"
  }
}

resource "aws_s3_bucket" "s3_bucket_tokens" {
  bucket  = "${var.appPrefix}-tokens"
  acl     = "private"
  versioning {
    enabled = false
  }
  tags = {
    Application = "${var.appName}"
    Env         = "${var.env}"
  }
}

output "website-endpoint" {
  value = "${aws_s3_bucket.s3_bucket_front.website_endpoint}"
}

output "websiteId" {
  value = "${aws_s3_bucket.s3_bucket_front.id}"
}

output "parseId" {
  value = "${aws_s3_bucket.s3_bucket_parse.id}"
}

output "tokensId" {
  value = "${aws_s3_bucket.s3_bucket_tokens.id}"
}

output "websiteArn" {
  value = "${aws_s3_bucket.s3_bucket_front.arn}"
}

output "parseArn" {
  value = "${aws_s3_bucket.s3_bucket_parse.arn}"
}

output "tokensArn" {
  value = "${aws_s3_bucket.s3_bucket_tokens.arn}"
}
