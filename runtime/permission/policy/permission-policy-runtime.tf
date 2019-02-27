variable "prefix" {
  type = "string"
}

variable "bucketNameFront" {
  type = "string"
}

variable "bucketNameParse" {
  type = "string"
}

variable "bucketNameTokens" {
  type = "string"
}

data "aws_iam_policy_document" "cloudwatchDataPolicy" {
  statement {
    sid = "putLogsEventsCloudWatch"
    actions = [
      "logs:PutLogEvents"
    ]
    resources = [
      "arn:aws:logs:*:*:log-group:/aws/lambda/*:*:*"]
  }
  statement {
    sid = "CreateLogsCloudWatch"
    actions = [
      "logs:CreateLogStream"
    ]
    resources = [
      "arn:aws:logs:*:*:log-group:/aws/lambda/*:*"]
  }
}

data "aws_iam_policy_document" "bucketDataPolicy" {
  statement {
    sid = "accessObjetsS3Bucket"
    actions = [
      "s3:ListBucket",
      "s3:GetObject*",
      "s3:PutObject*",
      "s3:DeleteObject*"
    ]
    resources = [
      "arn:aws:s3:::${var.bucketNameTokens}/*",
      "arn:aws:s3:::${var.bucketNameTokens}",
      "arn:aws:s3:::${var.bucketNameParse}/*",
      "arn:aws:s3:::${var.bucketNameParse}",
      "arn:aws:s3:::${var.bucketNameFront}/*",
      "arn:aws:s3:::${var.bucketNameFront}"]
  }
}



resource "aws_iam_policy" "cloudwatchPolicy" {
  name = "${var.prefix}-cloudwatch-logs"
  path = "/"
  description = "Otorga privilegios para la creacion de logs CloudWatch"
  policy = "${data.aws_iam_policy_document.cloudwatchDataPolicy.json}"
}

resource "aws_iam_policy" "bucketPolicy" {
  name = "${var.prefix}-s3"
  path = "/"
  description = "Otorga privilegios sobre los bucket del proyecto"
  policy = "${data.aws_iam_policy_document.bucketDataPolicy.json}"
}

output "outArnCloudwatchPolicy" {
  value = "${aws_iam_policy.cloudwatchPolicy.arn}"
}

output "outArnBucketPolicy" {
  value = "${aws_iam_policy.bucketPolicy.arn}"
}
