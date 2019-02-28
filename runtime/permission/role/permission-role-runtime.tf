variable "appPrefix" {
  type = "string"
}

variable "appName" {
  type = "string"
}

variable "env" {
  type = "string"
}

variable "cloudwatchPolicy" {
  type = "string"
}

variable "bucketsPolicy" {
  type = "string"
}


data "aws_iam_policy_document" "lambdaDataRole" {
  statement {
    actions = [
      "sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = [
        "lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambdaRole" {
  name = "${var.appPrefix}-back-lambda"
  assume_role_policy = "${data.aws_iam_policy_document.lambdaDataRole.json}"
  tags = {
    Application = "${var.appName}"
    Env = "${var.env}"
  }
}

resource "aws_iam_role_policy_attachment" "cloudwatchRoleAttach" {
  role = "${aws_iam_role.lambdaRole.name}"
  policy_arn = "${var.cloudwatchPolicy}"
  depends_on = [
    "aws_iam_role.lambdaRole"]
}

resource "aws_iam_role_policy_attachment" "bucketsRoleAttach" {
  role = "${aws_iam_role.lambdaRole.name}"
  policy_arn = "${var.bucketsPolicy}"
  depends_on = [
    "aws_iam_role.lambdaRole"]
}

output "lambdaRoleArn" {
  value = "${aws_iam_role.lambdaRole.arn}"
}
