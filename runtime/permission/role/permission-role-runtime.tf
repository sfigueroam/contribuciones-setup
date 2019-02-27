variable "prefix" {
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

variable "bucketPolicy" {
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
  name = "${var.prefix}-back-lambda"
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

resource "aws_iam_role_policy_attachment" "bucketRoleAttach" {
  role = "${aws_iam_role.lambdaRole.name}"
  policy_arn = "${var.bucketPolicy}"
  depends_on = [
    "aws_iam_role.lambdaRole"]
}

output "outArnLambdaRole" {
  value = "${aws_iam_role.lambdaRole.arn}"
}