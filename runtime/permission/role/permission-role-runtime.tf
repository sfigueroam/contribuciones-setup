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

variable "ec2Policy" {
  type = "string"
}

data "aws_iam_policy_document" "ec2DataRole" {
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

resource "aws_iam_role" "ec2Role" {
  name = "${var.appPrefix}-ec2-lambda"
  assume_role_policy = "${data.aws_iam_policy_document.ec2DataRole.json}"
  tags = {
    Application = "${var.appName}"
    Env = "${var.env}"
  }
}

resource "aws_iam_role_policy_attachment" "ec2RoleAttach" {
  role = "${aws_iam_role.ec2Role.name}"
  policy_arn = "${var.ec2Policy}"
  depends_on = [
    "aws_iam_role.ec2Role"]
}

resource "aws_iam_instance_profile" "ec2RoleInstanceProfile" {
  name = "${var.appPrefix}-ec2-lambda"
  role = "${aws_iam_role.ec2Role.name}"
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

resource "aws_iam_role" "lambdaBackRole" {
  name = "${var.appPrefix}-back-lambda"
  assume_role_policy = "${data.aws_iam_policy_document.lambdaDataRole.json}"
  tags = {
    Application = "${var.appName}"
    Env = "${var.env}"
  }
}

resource "aws_iam_role" "lambdaDireccionesRole" {
  name = "${var.appPrefix}-direcciones-lambda"
  assume_role_policy = "${data.aws_iam_policy_document.lambdaDataRole.json}"
  tags = {
    Application = "${var.appName}"
    Env = "${var.env}"
  }
}

resource "aws_iam_role_policy_attachment" "cloudwatchBackRoleAttach" {
  role = "${aws_iam_role.lambdaBackRole.name}"
  policy_arn = "${var.cloudwatchPolicy}"
  depends_on = [
    "aws_iam_role.lambdaBackRole"]
}

resource "aws_iam_role_policy_attachment" "bucketsBackRoleAttach" {
  role = "${aws_iam_role.lambdaBackRole.name}"
  policy_arn = "${var.bucketsPolicy}"
  depends_on = [
    "aws_iam_role.lambdaBackRole"]
}

resource "aws_iam_role_policy_attachment" "cloudwatchDireccionesRoleAttach" {
  role = "${aws_iam_role.lambdaDireccionesRole.name}"
  policy_arn = "${var.cloudwatchPolicy}"
  depends_on = [
    "aws_iam_role.lambdaDireccionesRole"]
}

resource "aws_iam_role_policy_attachment" "bucketDireccionesRoleAttach" {
  role = "${aws_iam_role.lambdaDireccionesRole.name}"
  policy_arn = "${var.bucketsPolicy}"
  depends_on = [
    "aws_iam_role.lambdaDireccionesRole"]
}


output "lambdaBackRoleArn" {
  value = "${aws_iam_role.lambdaBackRole.arn}"
}

output "lambdaDireccionesRoleArn" {
  value = "${aws_iam_role.lambdaDireccionesRole.arn}"
}

output "ec2InstanceProfileArn" {
  value = "${aws_iam_instance_profile.ec2RoleInstanceProfile.name}"
}