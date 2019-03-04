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

variable "repositoryBack" {
  type = "string"
}

variable "repositoryFront" {
  type = "string"
}

variable "apiGatewayID" {
  type = "string"
}

data "aws_iam_policy_document" "codecommitDataPolicy" {
  statement {
    sid = "codecommitAccess"
    actions = [
      "codecommit:*"
    ]
    resources = [
      "arn:aws:codecommit:*:${var.account}:${var.repositoryFront}",
      "arn:aws:codecommit:*:${var.account}:${var.repositoryBack}"
    ]
  }
}

resource "aws_iam_policy" "codecommitPolicy" {
  count = "${var.env=="dev" ? 1 : 0}"
  name = "${var.appPrefix}-codecommit"
  path = "/"
  description = "Otorga privilegios sobre repositorios codecommit de la aplicacion"
  policy = "${data.aws_iam_policy_document.codecommitDataPolicy.json}"
}

data "aws_iam_policy_document" "cloudwatchDataPolicy" {
  statement {
    sid = "cloudWatch"
    actions = [
      "logs:ListTagsLogGroup",
      "logs:DescribeQueries",
      "logs:GetLogRecord",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
      "logs:DescribeSubscriptionFilters",
      "logs:StartQuery",
      "logs:DescribeMetricFilters",
      "logs:StopQuery",
      "logs:TestMetricFilter",
      "logs:GetLogDelivery",
      "logs:ListLogDeliveries",
      "logs:DescribeExportTasks",
      "logs:GetQueryResults",
      "logs:GetLogEvents",
      "logs:FilterLogEvents",
      "logs:GetLogGroupFields",
      "logs:DescribeResourcePolicies",
      "logs:DescribeDestinations"
    ]
    resources = [
      "arn:aws:logs:*:*:log-group:/aws/lambda/*:*:*"]
  }
}

resource "aws_iam_policy" "cloudWatchPolicy" {
  count = "${var.env=="dev" ? 1 : 0}"
  name = "${var.appPrefix}-cloudWatch"
  path = "/"
  description = ""
  policy = "${data.aws_iam_policy_document.cloudwatchDataPolicy.json}"
}

data "aws_iam_policy_document" "lambdaDataPolicy" {
  statement {
    sid = "lambdaAccessFuntion"
    actions = [
      "lambda:InvokeFunction",
      "lambda:ListVersionsByFunction",
      "lambda:Get*",
      "lambda:ListAliases",
      "lambda:UpdateFunctionConfiguration",
      "lambda:InvokeAsync",
      "lambda:UpdateAlias",
      "lambda:UpdateFunctionCode",
      "lambda:ListTags",
      "lambda:PublishVersion",
      "lambda:CreateAlias"
    ]
    resources = [
      "arn:aws:lambda:*:*:function:*${var.appName}*"
    ]
  }
  statement {
    sid = "lambdaAccessList"
    actions = [
      "lambda:List*",
      "lambda:Get*"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "lambdaPolicy" {
  count = "${var.env=="dev" ? 1 : 0}"
  name = "${var.appPrefix}-lambda"
  path = "/"
  description = "Otorga privilegios a las funciones lambda de la aplicacion"
  policy = "${data.aws_iam_policy_document.lambdaDataPolicy.json}"
}


data "aws_iam_policy_document" "apiGatewayDataPolicy" {
  statement {
    sid = "apiGatewayAccess"
    actions = [
      "apigateway:PUT",
      "apigateway:PATCH",
      "apigateway:POST",
      "apigateway:GET"
    ]
    resources = [
      "arn:aws:apigateway:*::/restapis/${var.apiGatewayID}/*"
    ]
  }
}

resource "aws_iam_policy" "apiGatewayPolicy" {
  count = "${var.env=="dev" ? 1 : 0}"
  name = "${var.appPrefix}-apigateway"
  path = "/"
  description = "Otorga privilegios a la api de la aplicacion"
  policy = "${data.aws_iam_policy_document.apiGatewayDataPolicy.json}"
}

output "codecommitPolicyArn" {
  value = "${element(concat(aws_iam_policy.codecommitPolicy.*.arn, list("")), 0)}"
}

output "lambdaPolicyArn" {
  value = "${element(concat(aws_iam_policy.lambdaPolicy.*.arn, list("")), 0)}"
}

output "apiGatewayPolicyArn" {
  value = "${element(concat(aws_iam_policy.apiGatewayPolicy.*.arn, list("")), 0)}"
}

output "cloudWatchPolicyArn" {
  value = "${element(concat(aws_iam_policy.cloudWatchPolicy.*.arn, list("")), 0)}"
}

