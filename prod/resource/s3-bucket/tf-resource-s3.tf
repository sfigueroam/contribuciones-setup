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

output "out_s3_bucket_direcciones_name" {
  value = "${aws_s3_bucket.s3_bucket_direcciones.id}"
}

