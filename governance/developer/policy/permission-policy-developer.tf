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
    condition {
      test="StringLikeIfExists"
      variable="codecommit:References"
      values=[
        "refs/heads/develop",
        "refs/heads/develop/*"]
    }
  }
}

resource "aws_iam_policy" "codecommitPolicy" {
  count = "${var.env=="dev" ? 1 : 0}"
  name = "${var.appPrefix}-codecommit"
  path = "/"
  description = "Otorga privilegios sobre repositorios codecommit de la aplicacion"
  policy = "${data.aws_iam_policy_document.codecommitDataPolicy.json}"
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

data "aws_iam_policy_document" "cloudwatchDataPolicy" {
  statement {
    sid = "cloudWatchListAccess"
    actions = [
      "logs:Describe*",
      "logs:List*"
    ]
    resources = ["*"]
  }
  statement {
    sid = "cloudWatchAccess"
    actions = [
      "logs:Get*",
      "logs:TestMetricFilter",
      "logs:FilterLogEvents"
    ]
    resources = [
      "arn:aws:logs:*:*:log-group:/aws/lambda/*${var.appName}*:*:*",
      "arn:aws:logs:*:*:log-group:/aws/codebuild/*${var.appName}*:*:*"
    ]
  }
}

resource "aws_iam_policy" "cloudWatchPolicy" {
  count = "${var.env=="dev" ? 1 : 0}"
  name = "${var.appPrefix}-cloudWatch"
  path = "/"
  description = ""
  policy = "${data.aws_iam_policy_document.cloudwatchDataPolicy.json}"
}

data "aws_iam_policy_document" "codepipelineDataPolicy" {
  statement {
    sid = "listAccess"
    actions = [
      "codepipeline:ListPipelines",
      "codebuild:ListBuilds",
      "codebuild:ListBuildsForProject",
      "codebuild:ListProjects",
      "codebuild:BatchGetProjects"
    ]
    resources = [
      "*"
    ]
  }
  statement {
    sid = "codepipelineAccess"
    actions = [
      "codepipeline:GetPipeline",
      "codepipeline:GetPipelineState",
      "codepipeline:GetPipelineExecution",
      "codepipeline:ListPipelineExecutions",
      "codepipeline:ListActionTypes"
    ]
    resources = [
      "arn:aws:codepipeline:*:*:${var.appPrefix}*"
    ]
  }
  statement {
    sid = "codebuildAccess"
    actions = [
      "codepipeline:BatchGetBuilds",
      "codepipeline:BatchGetProjects",
      "codepipeline:ListConnectedOAuthAccounts",
      "codepipeline:ListCuratedEnvironmentImages",
      "codepipeline:ListRepositories"
    ]
    resources = [
      "arn:aws:codebuild:*:*:project/${var.appPrefix}*"
    ]
  }
}

resource "aws_iam_policy" "codepipelinePolicy" {
  count = "${var.env=="dev" ? 1 : 0}"
  name = "${var.appPrefix}-codepipeline"
  path = "/"
  description = "Otorga privilegios a los codepipeline y codebuild de la aplicacion"
  policy = "${data.aws_iam_policy_document.codepipelineDataPolicy.json}"
}

data "aws_iam_policy_document" "bucketsS3DataPolicy" {
  statement {
    sid = "bucketsAccess"
    actions = [
      "s3:Get*",
      "s3:List*"
    ]
    resources = [
      "arn:aws:s3:::${var.appPrefix}*",
      "arn:aws:s3:::${var.appPrefix}*/*"
    ]
  }
  statement {
    sid = "codebuildAccess"
    actions = [
      "codebuild:BatchGet*",
      "codebuild:Get*",
      "codebuild:List*",
    ]
    resources = [
      "arn:aws:codebuild:*:*:project/${var.appPrefix}*"
    ]
  }

}

resource "aws_iam_policy" "bucketsS3Policy" {
  count = "${var.env=="dev" ? 1 : 0}"
  name = "${var.appPrefix}-s3-buckets"
  path = "/"
  description = "Otorga privilegios a los codepipeline y codebuild de la aplicacion"
  policy = "${data.aws_iam_policy_document.bucketsS3DataPolicy.json}"
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

output "codepipelinePolicyArn" {
  value = "${element(concat(aws_iam_policy.codepipelinePolicy.*.arn, list("")), 0)}"
}

output "bucketsS3PolicyArn" {
  value = "${element(concat(aws_iam_policy.bucketsS3Policy.*.arn, list("")), 0)}"
}
