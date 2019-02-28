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