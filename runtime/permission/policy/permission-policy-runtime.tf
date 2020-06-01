variable "account" {
  type = "string"
}

variable "appName" {
  type = "string"
}

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

variable "direccionesBucketID" {
  type = "string"
}


variable "env" {
  type = "string"
}

data "aws_region" "current" {
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

resource "aws_iam_policy" "cloudwatchPolicy" {
  name = "${var.appPrefix}-cloudwatch-logs"
  path = "/"
  description = "Otorga privilegios para la creacion de logs CloudWatch"
  policy = "${data.aws_iam_policy_document.cloudwatchDataPolicy.json}"
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
      "arn:aws:s3:::${var.frontBucketID}",
      "arn:aws:s3:::${var.direccionesBucketID}/*",
      "arn:aws:s3:::${var.direccionesBucketID}"]
  }
}

resource "aws_iam_policy" "bucketPolicy" {
  name = "${var.appPrefix}-s3"
  path = "/"
  description = "Otorga privilegios sobre los bucket del proyecto"
  policy = "${data.aws_iam_policy_document.bucketDataPolicy.json}"
}



data "aws_iam_policy_document" "lambdaDataPolicy" {
  
  statement {
    sid = "stmtDynamoDB"
    actions = [
      "dynamodb:*"
    ]
    resources = [
      "arn:aws:dynamodb:us-east-1:*:table/${var.appPrefix}*",
      "arn:aws:dynamodb:us-east-1:*:table/${var.appPrefix}*/index/*"
    ]
  }
}

data "aws_iam_policy_document" "ec2LambdaDataPolicy" {
  statement {
    sid = "invokeFuntionDirecciones"
    actions = [
      "lambda:InvokeFunction"
    ]
    resources = [
      "arn:aws:lambda:*:*:function:${var.appPrefix}-elasticDirecciones"]
  }
  

}

resource "aws_iam_policy" "ec2LambdaPolicy" {
  name = "${var.appPrefix}-lambda-direcciones"
  path = "/"
  description = "Otorga privilegios para la ejecutar lambda direcciones"
  policy = "${data.aws_iam_policy_document.ec2LambdaDataPolicy.json}"
}

resource "aws_iam_policy" "lambdaPolicy" {
  name = "${var.appPrefix}-back-lambda"
  path = "/"
  description = "Otorga privilegios de ejecución de lambdas"
  policy = "${data.aws_iam_policy_document.lambdaDataPolicy.json}"
}

data "aws_iam_policy_document" "elasticsearchDataPolicy" {
  statement {
    sid = "elasticsearchAccess"
    actions = [
      "es:*"
    ]
    resources = [
      "arn:aws:es:${data.aws_region.current.name}:${var.account}:domain/${var.appPrefix}"]
  }
  
}

resource "aws_iam_policy" "elasticsearchPolicy" {
  name = "${var.appPrefix}-elasticsearch-lambda"
  path = "/"
  description = "Otorga privilegios para la crear indices en elasticsearch"
  policy = "${data.aws_iam_policy_document.elasticsearchDataPolicy.json}"
}

output "cloudwatchPolicyArn" {
  value = "${aws_iam_policy.cloudwatchPolicy.arn}"
}

output "bucketsPolicyArn" {
  value = "${aws_iam_policy.bucketPolicy.arn}"
}

output "ec2LambdaPolicyArn" {
  value = "${aws_iam_policy.ec2LambdaPolicy.arn}"
}

output "elasticsearchPolicyArn" {
  value = "${aws_iam_policy.elasticsearchPolicy.arn}"
}

output "lambdaPolicyArn" {
  value = "${aws_iam_policy.lambdaPolicy.arn}"
}