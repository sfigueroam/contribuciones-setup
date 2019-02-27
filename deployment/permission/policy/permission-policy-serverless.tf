variable "account" {
  type = "string"
}

variable "prefix" {
  type = "string"
}

variable "appName" {
  type = "string"
}

variable "env" {
  type = "string"
}

variable "apiGatewayID" {
  type = "string"
}

data "aws_iam_policy_document" "serverlessDataPolicy" {
  statement {
    actions = [
      "cloudformation:CreateUploadBucket",
      "cloudformation:Describe*",
      "cloudformation:Get*",
      "cloudformation:List*",
      "cloudformation:ValidateTemplate",
      "lambda:CreateFunction",
      "lambda:ListFunctions",
      "lambda:ListVersionsByFunction",
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
      "logs:DeleteLogGroup",
      "logs:DeleteLogStream",
      "logs:PutLogEvents",
      "s3:CreateBucket",
      "s3:ListBucket",
      "s3:GetObject*",
      "s3:GetEncryptionConfiguration",
      "s3:PutEncryptionConfiguration",
      "kms:Decrypt",
      "kms:Encrypt"
    ]
    resources = [
      "*"
    ]
  }
  statement {
    actions = [
      "cloudformation:DeleteStack",
      "cloudformation:DescribeStackResource",
      "cloudformation:DescribeStackEvents",
      "cloudformation:DescribeStackResources",
      "cloudformation:CancelUpdateStack",
      "cloudformation:ContinueUpdateRollback",
      "cloudformation:CreateStack",
      "cloudformation:GetStackPolicy",
      "cloudformation:GetTemplate",
      "cloudformation:UpdateStack",
      "cloudformation:UpdateTerminationProtection",
      "cloudformation:SignalResource",
      "iam:CreateRole",
      "iam:DeleteRole",
      "iam:DeleteRolePolicy",
      "iam:GetRole",
      "iam:PassRole",
      "iam:PutRolePolicy",
      "lambda:UpdateFunctionCode",
      "lambda:UpdateFunctionConfiguration",
      "s3:PutObject",

    ]
    resources = [
      "arn:aws:cloudformation:*:*:stack/${var.prefix}*/*",
      "arn:aws:iam::*:role/${var.prefix}*",
      //"arn:aws:s3:::${var.prefix}*/*",
      "arn:aws:s3:::${length(var.prefix)>=24 ? substr(var.prefix, 0, min(length(var.prefix), 24)) : var.prefix}*/*",
      "arn:aws:lambda:us-east-1:${var.account}:function:${var.prefix}*"
    ]
  }
  statement {
    actions = [
      "apigateway:DELETE",
      "apigateway:HEAD",
      "apigateway:GET",
      "apigateway:OPTIONS",
      "apigateway:POST",
      "apigateway:PUT"
    ]
    resources = [
      "arn:aws:apigateway:*::/restapis/${var.apiGatewayID}/*"
    ]
  }
  statement {
    actions = [
      "lambda:GetFunctionConfiguration",
      "s3:GetObject"
    ]
    resources = [
      "arn:aws:s3:::${length(var.prefix)>=24 ? substr(var.prefix, 0, min(length(var.prefix), 24)) : var.prefix}*/*",
      "arn:aws:lambda:*:${var.account}:function:${var.prefix}*"
    ]
  }
  statement {
    actions = [
      "lambda:RemovePermission"
    ]
    resources = [
      "arn:aws:lambda:*:${var.account}:function:${var.prefix}*",
      "arn:aws:lambda:us-east-1:${var.account}:function:${var.prefix}*"

    ]
  }
  statement {
    actions = [
      "lambda:DeleteFunction"
    ]
    resources = [
      "arn:aws:lambda:*:${var.account}:function:${var.prefix}*",
      "arn:aws:lambda:us-east-1:${var.account}:function:${var.prefix}*"

    ]
  }
  statement {
    actions = [
      "lambda:GetFunction"
    ]
    resources = [
      "arn:aws:lambda:*:${var.account}:function:${var.prefix}*",
      "arn:aws:lambda:us-east-1:${var.account}:function:${var.prefix}*"

    ]
  }
  statement {
    actions = [
      "lambda:AddPermission"
    ]
    resources = [
      "arn:aws:lambda:*:${var.account}:function:${var.prefix}*"
    ]
  }
  statement {
    actions = [
      "lambda:PublishVersion"
    ]
    resources = [
      "arn:aws:lambda:*:${var.account}:function:${var.prefix}*"
    ]
  }
  statement {
    actions = [
      "ssm:GetParameters"
    ]
    resources = [
      "arn:aws:ssm:*:*:parameter/tgr/${var.env}/${var.appName}/*"
    ]
  }
}

resource "aws_iam_policy" "serverlessPolicy" {
  name = "${var.prefix}-serverless-deploy"
  path = "/"
  description = "Otorga privilegios para realizar deploy serverless"
  policy = "${data.aws_iam_policy_document.serverlessDataPolicy.json}"
}

output "outArnServerlessPolicy" {
  value = "${aws_iam_policy.serverlessPolicy.arn}"
}


