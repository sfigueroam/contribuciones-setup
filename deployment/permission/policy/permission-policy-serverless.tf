variable "account" {
  type = "string"
}

variable "appPrefix" {
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
      "events:Put*",
      "events:DeleteRule",
      "events:DisableRule",
      "events:EnableRule",
      "events:Remove*",
      "events:DescribeRule",
      "events:DescribeEventBus",
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
      "arn:aws:cloudformation:*:*:stack/${var.appPrefix}*/*",
      "arn:aws:iam::*:role/${var.appPrefix}*",
      //"arn:aws:s3:::${var.appPrefix}*/*",
      "arn:aws:s3:::${length(var.appPrefix)>=24 ? substr(var.appPrefix, 0, min(length(var.appPrefix), 24)) : var.appPrefix}*/*",
      "arn:aws:lambda:us-east-1:${var.account}:function:${var.appPrefix}*"
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
      "arn:aws:s3:::${length(var.appPrefix)>=24 ? substr(var.appPrefix, 0, min(length(var.appPrefix), 24)) : var.appPrefix}*/*",
      "arn:aws:lambda:*:${var.account}:function:${var.appPrefix}*"
    ]
  }
  statement {
    actions = [
      "lambda:RemovePermission"
    ]
    resources = [
      "arn:aws:lambda:*:${var.account}:function:${var.appPrefix}*",
      "arn:aws:lambda:us-east-1:${var.account}:function:${var.appPrefix}*"

    ]
  }
  statement {
    actions = [
      "lambda:DeleteFunction"
    ]
    resources = [
      "arn:aws:lambda:*:${var.account}:function:${var.appPrefix}*",
      "arn:aws:lambda:us-east-1:${var.account}:function:${var.appPrefix}*"

    ]
  }
  statement {
    actions = [
      "lambda:GetFunction"
    ]
    resources = [
      "arn:aws:lambda:*:${var.account}:function:${var.appPrefix}*",
      "arn:aws:lambda:us-east-1:${var.account}:function:${var.appPrefix}*"

    ]
  }
  statement {
    actions = [
      "lambda:AddPermission"
    ]
    resources = [
      "arn:aws:lambda:*:${var.account}:function:${var.appPrefix}*"
    ]
  }
  statement {
    actions = [
      "lambda:PublishVersion"
    ]
    resources = [
      "arn:aws:lambda:*:${var.account}:function:${var.appPrefix}*"
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
  name = "${var.appPrefix}-serverless-deploy"
  path = "/"
  description = "Otorga privilegios para realizar deploy serverless"
  policy = "${data.aws_iam_policy_document.serverlessDataPolicy.json}"
}

output "serverlessPolicyArn" {
  value = "${aws_iam_policy.serverlessPolicy.arn}"
}


