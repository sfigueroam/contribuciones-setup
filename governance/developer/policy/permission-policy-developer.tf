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

variable "repositoryDirecciones" {
  type = "string"
}

variable "apiGatewayID" {
  type = "string"
}

data "aws_region" "current" {
}

data "aws_iam_policy_document" "codecommitDataPolicy" {
  statement {
    sid = "codecommitAccess"
    actions = [
      "codecommit:List*"
    ]
    resources = ["*"]
  }
  statement {
    sid = "codecommitAccessDevelopBranch"
    actions = [
      "codecommit:Batch*",
      "codecommit:CancelUploadArchive",
      "codecommit:DescribePullRequestEvents",
      "codecommit:Get*",
      "codecommit:GitPull",
      "codecommit:CreatePullRequest",
      "codecommit:DeleteCommentContent",
      "codecommit:DeleteFile",
      "codecommit:GitPush",
      "codecommit:MergePullRequestByFastForward",
      "codecommit:PostCommentForComparedCommit",
      "codecommit:PostCommentForPullRequest",
      "codecommit:PostCommentReply",
      "codecommit:PutFile",
      "codecommit:UpdateComment",
      "codecommit:UpdatePullRequestDescription",
      "codecommit:UpdatePullRequestStatus",
      "codecommit:UpdatePullRequestTitle",
      "codecommit:UploadArchive"
    ]
    resources = [
      "arn:aws:codecommit:*:${var.account}:${var.repositoryFront}",
      "arn:aws:codecommit:*:${var.account}:${var.repositoryBack}",
      "arn:aws:codecommit:*:${var.account}:${var.repositoryDirecciones}"
    ]
    condition {
      test="StringLikeIfExists"
      variable="codecommit:References"
      values=[
        "refs/heads/develop"]
    }
  }
  statement {
    sid = "codecommitAccessFeatureBranch"
    actions = [
      "codecommit:Batch*",
      "codecommit:CancelUploadArchive",
      "codecommit:DescribePullRequestEvents",
      "codecommit:Get*",
      "codecommit:GitPull",
      "codecommit:CreatePullRequest",
      "codecommit:Delete*",
      "codecommit:GitPush",
      "codecommit:MergePullRequestByFastForward",
      "codecommit:Post*",
      "codecommit:PutFile",
      "codecommit:Update*",
    ]
    resources = [
      "arn:aws:codecommit:*:${var.account}:${var.repositoryFront}",
      "arn:aws:codecommit:*:${var.account}:${var.repositoryBack}",
      "arn:aws:codecommit:*:${var.account}:${var.repositoryDirecciones}"
    ]
    condition {
      test="StringLikeIfExists"
      variable="codecommit:References"
      values=[
        "refs/heads/feature",
        "refs/heads/feature/*"]
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
  description = "Otorga privilegios a los logs de la aplicacion"
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
      "codebuild:BatchGetProjects",
      "codebuild:BatchGetBuilds"
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
      "codebuild:BatchGetBuilds",
      "codebuild:BatchGetProjects",
      "codebuild:ListConnectedOAuthAccounts",
      "codebuild:ListCuratedEnvironmentImages",
      "codebuild:ListRepositories"
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
    sid = "listBucketsAccess"
    actions = [
      "s3:List*",
    ]
    resources = [
      "*"
    ]
  }
  statement {
    sid = "bucketsAccess"
    actions = [
      "s3:Get*",
      "s3:Put*",
      "s3:DeleteObject*",
    ]
    resources = [
      "arn:aws:s3:::${var.appPrefix}*",
      "arn:aws:s3:::${var.appPrefix}*/*"
    ]
  }
}

resource "aws_iam_policy" "bucketsS3Policy" {
  count = "${var.env=="dev" ? 1 : 0}"
  name = "${var.appPrefix}-s3-buckets"
  path = "/"
  description = "Otorga privilegios a los buckets de la aplicacion"
  policy = "${data.aws_iam_policy_document.bucketsS3DataPolicy.json}"
}

data "aws_iam_policy_document" "parametersDataPolicy" {
  statement {
    sid = "listParametersAccess"
    actions = [
      "ssm:DescribeParameters",
      "kms:ListAliases"
    ]
    resources = [
      "*"
    ]
  }
  statement {
    sid = "parametersAccess"
    actions = [
      "ssm:GetParameterHistory",
      "ssm:DescribeDocumentParameters",
      "ssm:GetParametersByPath",
      "ssm:GetParameters",
      "ssm:GetParameter",
      "ssm:PutParameter",
      "ssm:DeleteParameter",
      "ssm:DeleteParameters"
    ]
    resources = [
      "arn:aws:ssm:*:*:parameter/tgr/${var.env}/${var.appName}/*"
    ]
  }
}

resource "aws_iam_policy" "parametersPolicy" {
  count = "${var.env=="dev" ? 1 : 0}"
  name = "${var.appPrefix}-s3-ssm-parameters"
  path = "/"
  description = "Otorga privilegios a los parametros de la aplicacion"
  policy = "${data.aws_iam_policy_document.parametersDataPolicy.json}"
}


data "aws_iam_policy_document" "elasticsearchDataPolicy" {
  statement {
    sid = "listElasticsearchAccess"
    actions = [
      "es:DescribeReservedElasticsearchInstanceOfferings",
      "es:DescribeReservedElasticsearchInstances",
      "es:ListDomainNames",
      "es:ListElasticsearchInstanceTypes",
      "es:DescribeElasticsearchInstanceTypeLimits",
      "es:ListElasticsearchVersions",
      "es:ESHttpHead",
      "es:ESHttpGet"

    ]
    resources = [
      "*"
    ]
  }
  statement {
    sid = "elasticsearchAccess"
    actions = [
      "es:DescribeElasticsearchDomain",
      "es:GetCompatibleElasticsearchVersions",
      "es:DescribeElasticsearchDomainConfig",
      "es:GetUpgradeStatus",
      "es:ListTags",
      "es:DescribeElasticsearchDomains",
      "es:GetUpgradeHistory",
      "es:ESHttpDelete",
      "es:ESHttpPut",
      "es:ESHttpPost"
    ]
    resources = [
      "arn:aws:es:${data.aws_region.current.name}:${var.account}:domain/${var.appPrefix}"
    ]
  }
}

resource "aws_iam_policy" "elasticsearchPolicy" {
  count = "${var.env=="dev" ? 1 : 0}"
  name = "${var.appPrefix}-elasticsearch"
  path = "/"
  description = "Otorga privilegios a elasticseach de la aplicacion"
  policy = "${data.aws_iam_policy_document.elasticsearchDataPolicy.json}"
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

output "parametersPolicyArn" {
  value = "${element(concat(aws_iam_policy.parametersPolicy.*.arn, list("")), 0)}"
}

output "elasticsearchPolicyArn" {
  value = "${element(concat(aws_iam_policy.elasticsearchPolicy.*.arn, list("")), 0)}"
}