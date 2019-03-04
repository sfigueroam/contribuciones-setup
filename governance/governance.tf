variable "account" {
  type = "string"
  description = "Numero de la cuenta donde se crean los recursos."
}

variable "env" {
  type = "string"
  description = "El ambiente donde se trabaja dev,qa,prod,lab."
}

variable "appName" {
  type = "string"
  description = "Nombre de la aplicacion."
}

variable "serverlessPolicyArn" {
  type = "string"
}

variable "repositoryFront" {
  type = "string"
}

variable "repositoryBack" {
  type = "string"
}

variable "appPrefix" {
  type = "string"
}

variable "apiGatewayId" {
  type = "string"
}

module "governancePermissionPolicy" {
  source = "./developer/policy"
  account = "${var.account}"
  appPrefix = "${var.appPrefix}"
  appName = "${var.appName}"
  env = "${var.env}"
  repositoryBack = "${var.repositoryBack}"
  repositoryFront = "${var.repositoryFront}"
  apiGatewayID = "${var.apiGatewayId}"
}

module "governancePermissionGroup" {
  source = "./developer/group"
  appName = "${var.appName}"
  env = "${var.env}"
  lambdaPolicyArn = "${module.governancePermissionPolicy.lambdaPolicyArn}"
  codecommitPolicyArn = "${module.governancePermissionPolicy.codecommitPolicyArn}"
  apiGatewayPolicyArn = "${module.governancePermissionPolicy.apiGatewayPolicyArn}"
  cloudWatchPolicyArn = "${module.governancePermissionPolicy.cloudWatchPolicyArn}"
  codepipelinePolicyArn = "${module.governancePermissionPolicy.codepipelinePolicyArn}"
  bucketsS3PolicyArn = "${module.governancePermissionPolicy.bucketsS3PolicyArn}"
}

module "governancePermisionRole" {
  source = "./developer/role"
  prefix = "${var.appPrefix}"
  appName = "${var.appName}"
  env = "${var.env}"
  serverlessPolicyArn = "${var.serverlessPolicyArn}"
}