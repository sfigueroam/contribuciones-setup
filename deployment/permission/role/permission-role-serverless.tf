variable "appPrefix" {
  type = "string"
}

variable "appName" {
  type = "string"
}

variable "env" {
  type = "string"
}

variable "serverlessPolicyArn" {
  type = "string"
}

data "aws_iam_policy_document" "servelessDataRole" {
  statement {
    actions = [
      "sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = [
        "codebuild.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "serverlessRole" {
  name = "${var.appPrefix}-codebuild-back-deployment"
  description = "Otorga privilegios para realizar deploy serverless en codebuild"
  assume_role_policy = "${data.aws_iam_policy_document.servelessDataRole.json}"
  tags = {
    Application = "${var.appName}"
    Env = "${var.env}"
  }
}

resource "aws_iam_role_policy_attachment" "serverlessRoleAttach" {
  role = "${aws_iam_role.serverlessRole.name}"
  policy_arn = "${var.serverlessPolicyArn}"
  depends_on = [
    "aws_iam_role.serverlessRole"]
}


output "serverlessRoleArn" {
  value = "${aws_iam_role.serverlessRole.arn}"
}

