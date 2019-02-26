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

variable "arnServerlessPolicy" {
  default = ""
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
  prefix = "${var.appPrefix}"
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
  arnLambdaPolicy = "${module.governancePermissionPolicy.outArnLambdaPolicy}"
  arnCodecommitPolicy = "${module.governancePermissionPolicy.outArnCodecommitPolicy}"
  arnApiGatewayPolicy = "${module.governancePermissionPolicy.outArnApiGatewayPolicy}"
}

module "governancePermisionRole" {
  source = "./developer/role"
  prefix = "${var.appPrefix}"
  appName = "${var.appName}"
  env = "${var.env}"
  arnServerlessPolicy = "${var.arnServerlessPolicy}"
}