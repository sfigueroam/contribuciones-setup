variable "prefix" {
  type = "string"
}

variable "appName" {
  type = "string"
}

variable "env" {
  type = "string"
}

/*
variable "dyndbPolicy" {
  type        = "string"
}
variable "sesPolicy" {
  type        = "string"
}
*/

variable "cloudwatchPolicy" {
  type = "string"
}

data "aws_iam_policy_document" "data_role_lambda" {
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

resource "aws_iam_role" "role_lambda" {
  name = "${var.prefix}-back-lambda"
  assume_role_policy = "${data.aws_iam_policy_document.data_role_lambda.json}"
  tags = {
    Application = "${var.appName}"
    Env = "${var.env}"
  }
}

/*
resource "aws_iam_role_policy_attachment" "role_lambda_attachment_dyndb" {
  role       = "${aws_iam_role.role_lambda.name}"
  policy_arn = "${var.dyndbPolicy}"
  depends_on = ["aws_iam_role.role_lambda"]
}

resource "aws_iam_role_policy_attachment" "role_lambda_attachment_ses" {
  role       = "${aws_iam_role.role_lambda.name}"
  policy_arn = "${var.sesPolicy}"
  depends_on = ["aws_iam_role.role_lambda"]
}
*/

resource "aws_iam_role_policy_attachment" "role_lambda_attachment_cloudwatch" {
  role = "${aws_iam_role.role_lambda.name}"
  policy_arn = "${var.cloudwatchPolicy}"
  depends_on = [
    "aws_iam_role.role_lambda"]
}

output "out_arn_role_lambda" {
  value = "${aws_iam_role.role_lambda.arn}"
}
