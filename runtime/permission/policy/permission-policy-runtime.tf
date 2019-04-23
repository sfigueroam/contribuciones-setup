variable "appPrefix" {
  type = "string"
}

variable "frontBucketID" {
  type = "string"
}

variable "parseBucketID" {
  type = "string"
}

variable "tokensBucketID" {
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
      "arn:aws:s3:::${var.tokensBucketID}/*",
      "arn:aws:s3:::${var.tokensBucketID}",
      "arn:aws:s3:::${var.parseBucketID}/*",
      "arn:aws:s3:::${var.parseBucketID}",
      "arn:aws:s3:::${var.frontBucketID}/*",
      "arn:aws:s3:::${var.frontBucketID}"]
  }
}

resource "aws_iam_policy" "cloudwatchPolicy" {
  name = "${var.appPrefix}-cloudwatch-logs"
  path = "/"
  description = "Otorga privilegios para la creacion de logs CloudWatch"
  policy = "${data.aws_iam_policy_document.cloudwatchDataPolicy.json}"
}

resource "aws_iam_policy" "bucketPolicy" {
  name = "${var.appPrefix}-s3"
  path = "/"
  description = "Otorga privilegios sobre los bucket del proyecto"
  policy = "${data.aws_iam_policy_document.bucketDataPolicy.json}"
}

data "aws_iam_policy_document" "ec2DataPolicy" {
  statement {
    sid = "invokeFuntionDirecciones"
    actions = [
      "lambda:InvokeFunction"
    ]
    resources = [
      "arn:aws:lambda:*:*:function:${var.appPrefix}-elasticDirecciones"]
  }
}

resource "aws_iam_policy" "ec2Policy" {
  name = "${var.appPrefix}-lambda-direcciones"
  path = "/"
  description = "Otorga privilegios para la ejecutar lambda direcciones"
  policy = "${data.aws_iam_policy_document.ec2DataPolicy.json}"
}

output "cloudwatchPolicyArn" {
  value = "${aws_iam_policy.cloudwatchPolicy.arn}"
}

output "bucketsPolicyArn" {
  value = "${aws_iam_policy.bucketPolicy.arn}"
}

output "instancePolicyArn" {
  value = "${aws_iam_policy.ec2Policy.arn}"
}