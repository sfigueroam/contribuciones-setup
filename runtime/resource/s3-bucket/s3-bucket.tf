variable "appPrefix" {
  type = "string"
}
variable "appName" {
  type = "string"
}
variable "env" {
  type = "string"
}

resource "aws_s3_bucket" "bucketS3Front" {
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

resource "aws_s3_bucket" "bucketS3Parse" {
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

resource "aws_s3_bucket" "bucketS3Tokens" {
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

resource "aws_s3_bucket" "bucketS3Direcciones" {
  bucket  = "${var.appPrefix}-direcciones"
  acl     = "private"
  versioning {
    enabled = false
  }
  tags = {
    Application = "${var.appName}"
    Env         = "${var.env}"
  }
}



output "frontBucketWebsiteEndpoint" {
  value = "${aws_s3_bucket.bucketS3Front.website_endpoint}"
}

output "frontBucketID" {
  value = "${aws_s3_bucket.bucketS3Front.id}"
}

output "parseBucketID" {
  value = "${aws_s3_bucket.bucketS3Parse.id}"
}

output "tokensBucketID" {
  value = "${aws_s3_bucket.bucketS3Tokens.id}"
}

output "direccionesBucketID" {
  value = "${aws_s3_bucket.bucketS3Direcciones.id}"
}

output "frontBucketArn" {
  value = "${aws_s3_bucket.bucketS3Front.arn}"
}

output "parseBucketArn" {
  value = "${aws_s3_bucket.bucketS3Parse.arn}"
}

output "tokensBucketArn" {
  value = "${aws_s3_bucket.bucketS3Tokens.arn}"
}

output "direccionesBucketArn" {
  value = "${aws_s3_bucket.bucketS3Direcciones.arn}"
}