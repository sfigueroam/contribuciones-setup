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

variable "appPrefix" {
  type = "string"
  description = "Nombre de la aplicacion."
}

variable "repositoryFront" {
  type = "string"
}

variable "repositoryBack" {
  type = "string"
}

variable "repositoryDirecciones" {
  type = "string"
}

variable "apiGatewayID" {
  type = "string"
}

variable "apiGatewayRootID" {
  type = "string"
}

variable "frontBucketID" {
  type = "string"
}

variable "tokensBucketID" {
  type = "string"
}

variable "parseBucketID" {
  type = "string"
}

variable "endpointApiElasticsearch" {
  type = "string"
}

variable "endpointApiPublica" {
  type = "string"
}

variable "cognitoAuthorizeURL" {
  type = "string"
}

variable "cognitoLogoutURL" {
  type = "string"
}

variable "cognitoContribClientId" {
  type = "string"
}

variable "cognitoContribRedirectURI" {
  type = "string"
}

variable "cognitoContribLogoutURI" {
  type = "string"
}

variable "cognitoPoolArn" {
  type = "string"
}

variable "direccionesBucketID" {
  type = "string"
}

variable "elasticsearchEndpoint" {
  type = "string"
}

variable "kmsKeyDevQa" {
  type = "string"
  default = "arn:aws:kms:us-east-1:080540609156:key/b97e9595-822a-4c79-8c09-3eede504a639"
}

variable "kmsKeyProd" {
  type = "string"
  default = "arn:aws:kms:us-east-1:596659627869:key/f6a54825-c0a7-4900-8eed-2807422f294d"
}

variable "roleArnGetCodecommit" {
  type = "string"
  default = "arn:aws:iam::080540609156:role/tgr-dev-codepipelines-multi-cuenta"
  description = "Rol para obtener repositorio codecommit, y luego encriptarlo y dejarlo en S3, funciona para todos los ambientes"
}

variable "lambdaBackRoleArn" {
  type = "string"
}

variable "lambdaDireccionesRoleArn" {
  type = "string"
}

locals {
  cBuildRoleFront = "arn:aws:iam::${var.account}:role/tgr-${var.env}-project-setup-codebuild"
  cPipelineRoleBack = "arn:aws:iam::${var.account}:role/tgr-${var.env}-project-setup-codepipeline"
  cPipelineRoleFront = "arn:aws:iam::${var.account}:role/tgr-${var.env}-project-setup-codepipeline"
  cPipelineRoleDirecciones = "arn:aws:iam::${var.account}:role/tgr-${var.env}-project-setup-codepipeline"
  cPipelineBucket = "tgr-${var.env}-codepipelines"
  env = "${var.env == "stag" ? "prod" : var.env}"
}

data "terraform_remote_state" "contribucionesProdSetup" {
  count  = "${var.env=="stag" ? 0 : 1}"
  backend = "s3"
  config {
    bucket  = "tgr-${local.env}-terraform-state"
    key     = "tgr-${local.env}-contribuciones-setup"
    region  = "us-east-1"
  }
}

module "deploymentPermissionPolicy" {
  source = "./permission/policy"
  account = "${var.account}"
  appPrefix = "${var.appPrefix}"
  appName = "${var.appName}"
  env = "${var.env}"
  apiGatewayID = "${var.apiGatewayID}"
}

module "deploymentPermissionRole" {
  source = "./permission/role"
  appPrefix = "${var.appPrefix}"
  appName = "${var.appName}"
  env = "${var.env}"
  serverlessPolicyArn = "${module.deploymentPermissionPolicy.serverlessPolicyArn}"
}

module "deploymentCodepipelineFront" {
  source = "./codepipeline/front"
  appPrefix = "${var.appPrefix}"
  appName = "${var.appName}"
  env = "${var.env}"
  repository = "${var.repositoryFront}"
  cBuildRole = "${local.cBuildRoleFront}"
  cPipelineRole = "${local.cPipelineRoleFront}"
  cPipelineBucket = "${local.cPipelineBucket}"
  bucketFrontID = "${var.frontBucketID}"
  cognitoAuthorizeURL = "${var.cognitoAuthorizeURL}"
  cognitoLogoutURL = "${var.cognitoLogoutURL}"
  cognitoContribClientId = "${var.cognitoContribClientId}"
  cognitoContribRedirectURI = "${var.cognitoContribRedirectURI}"
  cognitoContribLogoutURI = "${var.cognitoContribLogoutURI}"
  backEndpoint="${var.endpointApiPublica}" //"${module.api-gateway.endpoint}"
  endpointApiElasticsearch="${var.endpointApiElasticsearch}" //"${var.endpointApiElasticsearch}"
  kmsKey = "${var.env=="prod" || var.env=="stag" ? var.kmsKeyProd : var.kmsKeyDevQa}"
  roleArnGetCodecommit = "${var.roleArnGetCodecommit}"
}

module "deploymentCodepipelineBack" {
  source = "./codepipeline/back"
  env = "${var.env}"
  appName = "${var.appName}"
  appPrefix = "${var.appPrefix}"
  apiGatewayID = "${var.apiGatewayID}"
  apiGatewayRootID = "${var.apiGatewayRootID}"
  bucketTokens = "${var.tokensBucketID}"
  bucketParse = "${var.parseBucketID}"
  cBuildRole = "${module.deploymentPermissionRole.serverlessRoleArn}"
  cPipelineBucket = "${local.cPipelineBucket}"
  cPipelineRole = "${local.cPipelineRoleBack}"
  lambdaRoleArn = "${var.lambdaBackRoleArn}"
  repository = "${var.repositoryBack}"
  cognitoPoolArn = "${var.cognitoPoolArn}"
  kmsKey = "${var.env=="prod" || var.env=="stag" ? var.kmsKeyProd : var.kmsKeyDevQa}"
  roleArnGetCodecommit = "${var.roleArnGetCodecommit}"
  elasticsearchURL ="${var.elasticsearchEndpoint}"
}

module "deploymentCodepipelineDirecciones" {
  source = "./codepipeline/direcciones"
  cBuildRole = "${module.deploymentPermissionRole.serverlessRoleArn}"
  cPipelineBucket = "${local.cPipelineBucket}"
  appName = "${var.appName}"
  appPrefix = "${var.appPrefix}"
  roleArnGetCodecommit = "${var.roleArnGetCodecommit}"
  kmsKey = "${var.env=="prod" || var.env=="stag" ? var.kmsKeyProd : var.kmsKeyDevQa}"
  cPipelineRole = "${local.cPipelineRoleDirecciones}"
  env = "${var.env}"
  repository = "${var.repositoryDirecciones}"
  direccionesBucketID = "${var.direccionesBucketID}"
  elasticsearchEndpoint = "${var.elasticsearchEndpoint}"
  lambdaDireccionesRoleArn = "${var.lambdaDireccionesRoleArn}"
}

output "serverlessPolicyArn" {
  value = "${module.deploymentPermissionPolicy.serverlessPolicyArn}"
}