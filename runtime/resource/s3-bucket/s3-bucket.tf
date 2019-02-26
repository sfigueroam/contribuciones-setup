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

output "outBucketFrontWebsiteEndpoint" {
  value = "${aws_s3_bucket.bucketS3Front.website_endpoint}"
}

output "outFrontBucketID" {
  value = "${aws_s3_bucket.bucketS3Front.id}"
}

output "outParseBucketId" {
  value = "${aws_s3_bucket.bucketS3Parse.id}"
}

output "outTokensBucketId" {
  value = "${aws_s3_bucket.bucketS3Tokens.id}"
}

output "outFrontBucketArn" {
  value = "${aws_s3_bucket.bucketS3Front.arn}"
}

output "outParseBucketArn" {
  value = "${aws_s3_bucket.bucketS3Parse.arn}"
}

output "outTokensBucketArn" {
  value = "${aws_s3_bucket.bucketS3Tokens.arn}"
}
