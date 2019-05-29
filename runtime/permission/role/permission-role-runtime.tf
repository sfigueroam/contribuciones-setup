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

variable "ec2LambdaPolicy" {
  type = "string"
}

variable "elasticsearchPolicy" {
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

resource "aws_iam_role_policy_attachment" "ec2LambdaRoleAttach" {
  role = "${aws_iam_role.ec2Role.name}"
  policy_arn = "${var.ec2LambdaPolicy}"
  depends_on = [
    "aws_iam_role.ec2Role"]
}

resource "aws_iam_role_policy_attachment" "ec2BucketsRoleAttach" {
  role = "${aws_iam_role.ec2Role.name}"
  policy_arn = "${var.bucketsPolicy}"
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

resource "aws_iam_role" "lambdaDireccionesRole" {
  name = "${var.appPrefix}-direcciones-lambda"
  assume_role_policy = "${data.aws_iam_policy_document.lambdaDataRole.json}"
  tags = {
    Application = "${var.appName}"
    Env = "${var.env}"
  }
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

resource "aws_iam_role_policy_attachment" "elasticsearchDireccionesRoleAttach" {
  role = "${aws_iam_role.lambdaDireccionesRole.name}"
  policy_arn = "${var.elasticsearchPolicy}"
  depends_on = [
    "aws_iam_role.lambdaDireccionesRole"]
}

resource "aws_iam_role_policy_attachment" "lambdaDireccionesRoleAttach" {
  role = "${aws_iam_role.lambdaDireccionesRole.name}"
  policy_arn = "${var.ec2LambdaPolicy}"
  depends_on = [
    "aws_iam_role.lambdaDireccionesRole"]
}

output "lambdaBackRoleArn" {
  value = "${aws_iam_role.lambdaRole.arn}"
}

output "lambdaDireccionesRoleArn" {
  value = "${aws_iam_role.lambdaDireccionesRole.arn}"
}

output "ec2InstanceProfileArn" {
  value = "${aws_iam_instance_profile.ec2RoleInstanceProfile.name}"
}