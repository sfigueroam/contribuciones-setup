variable "appName" {
  type = "string"
}

variable "env" {
  type = "string"
}

variable "appPrefix" {
  type = "string"
}

resource "aws_iam_group" "developGroup" {
  count = "${var.env=="dev" || var.env=="qa" ? 1 : 0}"
  name = "team-${var.env}-${var.appName}-tester"
  path = "/"
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
      "codecommit:DescribePullRequestEvents",
      "codecommit:Get*",
      "codecommit:CreatePullRequest",
      "codecommit:GitPush",
      "codecommit:MergePullRequestByFastForward",
      "codecommit:PostCommentForComparedCommit",
      "codecommit:PostCommentForPullRequest",
      "codecommit:PostCommentReply",
      "codecommit:UpdateComment",
      "codecommit:UpdatePullRequestDescription",
      "codecommit:UpdatePullRequestStatus",
      "codecommit:UpdatePullRequestTitle"
    ]
    resources = [
      "arn:aws:codecommit:*:*:*${var.appName}*"
    ]
    condition {
      test="StringLikeIfExists"
      variable="codecommit:References"
      values=[
        "refs/heads/release"]
    }
  }
}

resource "aws_iam_policy" "codecommitPolicy" {
  count = "${var.env=="dev" || var.env=="qa" ? 1 : 0}"
  name = "${var.appPrefix}-codecommit-tester"
  path = "/"
  description = "Otorga privilegios sobre repositorios codecommit de la aplicacion"
  policy = "${data.aws_iam_policy_document.codecommitDataPolicy.json}"
}

resource "aws_iam_group_policy_attachment" "codecommitPolicyAttach" {
  count      = "${var.env=="dev" || var.env=="qa" ? 1 : 0}"
  group      = "${aws_iam_group.developGroup.name}"
  policy_arn = "${aws_iam_policy.codecommitPolicy.arn}"
  depends_on = ["aws_iam_group.developGroup"]
}

data "aws_iam_policy_document" "bucketsS3DataPolicy" {
  statement {
    sid = "listBucketsAccess"
    actions = [
      "s3:List*",
      "s3:HeadBucket"
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
  count = "${var.env=="dev" || var.env=="qa" ? 1 : 0}"
  name = "${var.appPrefix}-s3-buckets-tester"
  path = "/"
  description = "Otorga privilegios a los buckets de la aplicacion"
  policy = "${data.aws_iam_policy_document.bucketsS3DataPolicy.json}"
}

resource "aws_iam_group_policy_attachment" "bucketsS3PolicyAttach" {
  count      = "${var.env=="dev" || var.env=="qa" ? 1 : 0}"
  group      = "${aws_iam_group.developGroup.name}"
  policy_arn = "${aws_iam_policy.bucketsS3Policy.arn}"
  depends_on = ["aws_iam_group.developGroup"]
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
  count = "${var.env=="dev" || var.env=="qa" ? 1 : 0}"
  name = "${var.appPrefix}-s3-ssm-parameters-tester"
  path = "/"
  description = "Otorga privilegios a los parametros de la aplicacion"
  policy = "${data.aws_iam_policy_document.parametersDataPolicy.json}"
}

resource "aws_iam_group_policy_attachment" "parametersPolicyAttach" {
  count="${var.env=="dev" || var.env=="qa" ? 1 : 0}"
  group="${aws_iam_group.developGroup.name}"
  policy_arn="${aws_iam_policy.parametersPolicy.arn}"
  depends_on=["aws_iam_group.developGroup" ]
}

data "aws_iam_policy_document" "servelessDataRole" {
  statement {
    actions = [
      "sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = [
        "ec2.amazonaws.com"]
    }
  }
}

output "codecommitPolicyArn" {
  //value = "${aws_iam_policy.codecommitPolicy.arn}"
  value = "${element(concat(aws_iam_policy.codecommitPolicy.*.arn, list("")), 0)}"
}

output "bucketsS3PolicyArn" {
  value = "${element(concat(aws_iam_policy.bucketsS3Policy.*.arn, list("")), 0)}"
}

output "parametersPolicyArn" {
  value = "${element(concat(aws_iam_policy.parametersPolicy.*.arn, list("")), 0)}"
}
