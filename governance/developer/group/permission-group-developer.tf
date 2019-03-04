variable "appName" {
  type = "string"
}

variable "env" {
  type = "string"
}

variable "codecommitPolicyArn" {
  type = "string"
}

variable "lambdaPolicyArn" {
  type = "string"
}

variable "apiGatewayPolicyArn" {
  type = "string"
}

variable "cloudWatchPolicyArn" {
  type = "string"
}

variable "codepipelinePolicyArn" {
  type = "string"
}

variable "bucketsS3PolicyArn" {
  type = "string"
}

resource "aws_iam_group" "developGroup" {
  count = "${var.env=="dev" ? 1 : 0}"
  name = "team-${var.env}-${var.appName}"
  path = "/"
}

resource "aws_iam_group_policy_attachment" "codecommitPolicyAttach" {
  count      = "${var.env=="dev" ? 1 : 0}"
  group      = "${aws_iam_group.developGroup.name}"
  policy_arn = "${var.codecommitPolicyArn}"
  depends_on = ["aws_iam_group.developGroup"]
}

resource "aws_iam_group_policy_attachment" "lambdaPolicyAttach" {
  count      = "${var.env=="dev" ? 1 : 0}"
  group      = "${aws_iam_group.developGroup.name}"
  policy_arn = "${var.lambdaPolicyArn}"
  depends_on = ["aws_iam_group.developGroup"]
}

resource "aws_iam_group_policy_attachment" "apiGatewayPolicyAttach" {
  count      = "${var.env=="dev" ? 1 : 0}"
  group      = "${aws_iam_group.developGroup.name}"
  policy_arn = "${var.apiGatewayPolicyArn}"
  depends_on = ["aws_iam_group.developGroup"]
}

resource "aws_iam_group_policy_attachment" "cloudWatchPolicyAttach" {
  count      = "${var.env=="dev" ? 1 : 0}"
  group      = "${aws_iam_group.developGroup.name}"
  policy_arn = "${var.cloudWatchPolicyArn}"
  depends_on = ["aws_iam_group.developGroup"]
}

resource "aws_iam_group_policy_attachment" "codepipelinePolicyAttach" {
  count      = "${var.env=="dev" ? 1 : 0}"
  group      = "${aws_iam_group.developGroup.name}"
  policy_arn = "${var.codepipelinePolicyArn}"
  depends_on = ["aws_iam_group.developGroup"]
}

resource "aws_iam_group_policy_attachment" "bucketsS3PolicyAttach" {
  count      = "${var.env=="dev" ? 1 : 0}"
  group      = "${aws_iam_group.developGroup.name}"
  policy_arn = "${var.bucketsS3PolicyArn}"
  depends_on = ["aws_iam_group.developGroup"]
}