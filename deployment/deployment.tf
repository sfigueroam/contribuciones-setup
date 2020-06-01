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

variable "kmsKeyArn" {
  type = "string"
}

variable "roleArnGetCodecommit" {
  type = "string"
}

variable "lambdaBackRoleArn" {
  type = "string"
}

variable "lambdaDireccionesRoleArn" {
  type = "string"
}

variable "beneficiosTableName" {
  type = "string"
}

variable "pipelineRoleArn" {
  type = "string"
}

variable "buildRoleArn" {
  type = "string"
}

variable "pipelineBucketName" {
  type = "string"
}

variable "branchMap" {
  type = "map"
}

locals {
  //cBuildRoleFront = "arn:aws:iam::${var.account}:role/tgr-${var.env}-project-setup-codebuild"
  //cPipelineRoleBack = "arn:aws:iam::${var.account}:role/tgr-${var.env}-project-setup-codepipeline"
  //cPipelineRoleFront = "arn:aws:iam::${var.account}:role/tgr-${var.env}-project-setup-codepipeline"
  //cPipelineRoleDirecciones = "arn:aws:iam::${var.account}:role/tgr-${var.env}-project-setup-codepipeline"
  //cPipelineBucket = "tgr-${var.env}-codepipelines"
  env = "${var.env == "stag" ? "prod" : var.env}"
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
  cBuildRole = "${var.buildRoleArn}"
  cPipelineRole = "${var.pipelineRoleArn}"
  cPipelineBucket = "${var.pipelineBucketName}"
  bucketFrontID = "${var.frontBucketID}"
  cognitoAuthorizeURL = "${var.cognitoAuthorizeURL}"
  cognitoLogoutURL = "${var.cognitoLogoutURL}"
  cognitoContribClientId = "${var.cognitoContribClientId}"
  cognitoContribRedirectURI = "${var.cognitoContribRedirectURI}"
  cognitoContribLogoutURI = "${var.cognitoContribLogoutURI}"
  backEndpoint="${var.endpointApiPublica}" //"${module.api-gateway.endpoint}"
  kmsKey = "${var.kmsKeyArn}"
  roleArnGetCodecommit = "${var.roleArnGetCodecommit}"
  branch = "${var.branchMap}"
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
  cPipelineBucket = "${var.pipelineBucketName}"
  cPipelineRole = "${var.pipelineRoleArn}"
  lambdaRoleArn = "${var.lambdaBackRoleArn}"
  repository = "${var.repositoryBack}"
  cognitoPoolArn = "${var.cognitoPoolArn}"
  kmsKey = "${var.kmsKeyArn}"
  roleArnGetCodecommit = "${var.roleArnGetCodecommit}"
  elasticsearchURL ="${var.elasticsearchEndpoint}"
  beneficiosTableName = "${var.beneficiosTableName}"
  branch = "${var.branchMap}"
}

module "deploymentCodepipelineDirecciones" {
  source = "./codepipeline/direcciones"
  cBuildRole = "${module.deploymentPermissionRole.serverlessRoleArn}"
  cPipelineBucket = "${var.pipelineBucketName}"
  appName = "${var.appName}"
  appPrefix = "${var.appPrefix}"
  roleArnGetCodecommit = "${var.roleArnGetCodecommit}"
  kmsKey = "${var.kmsKeyArn}"
  cPipelineRole = "${var.pipelineRoleArn}"
  env = "${var.env}"
  repository = "${var.repositoryDirecciones}"
  direccionesBucketID = "${var.direccionesBucketID}"
  elasticsearchEndpoint = "${var.elasticsearchEndpoint}"
  lambdaDireccionesRoleArn = "${var.lambdaDireccionesRoleArn}"
  branch = "${var.branchMap}"
}

output "serverlessPolicyArn" {
  value = "${module.deploymentPermissionPolicy.serverlessPolicyArn}"
}