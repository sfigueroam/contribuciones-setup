provider "aws" {
  region = "us-east-1"
  version = "~> 1.57"
}

variable "account" {
  type = "string"
  description = "Numero de la cuenta."
}

variable "frontAccount" {
  type = "string"
  description = "Numero de la cuenta donde se configurará Route53 y Cloudfront."
}

variable "env" {
  type = "string"
  description = "El ambiente donde se trabaja dev,qa,prod,lab."
}

variable "appName" {
  type = "string"
  description = "Nombre de la aplicacion."
}

variable "appFrontSubdomain" {
  type = "string"
  description = "Subdominio desde donde se accedera el frontend. Ejemplo: www"
}

variable "appFrontDomain" {
  type = "string"
  description = "Dominio desde donde se accedera el frontend. Ejemplo: tgr.cl"
}

variable "route53ZoneId" {
  type = "string"
}

variable "acmCertificateArn" {
  type = "string"
}

variable "cognitoPoolId" {
  type = "string"
}

variable "cognitoPoolArn" {
  type = "string"
}

variable "cognitoAuthorizeURL" {
  type = "string"
}

variable "cognitoLogoutURL" {
  type = "string"
}

variable "cognitoProviders" {
  type = "list"
}

variable "cognitoReadAttributes" {
  type = "list"
}

variable "endpointApiElasticsearch" {
  type = "string"
  default = "https://w2jmtnip5c.execute-api.us-east-1.amazonaws.com/dev"
}

variable "direccionesElasticsearchDomain" {
  type = "string"
  default = "search-tgr-qa-contribuciones-hsco4tfnkz2jfjpxxv3znhxnqu.us-east-1.es.amazonaws.com"
}

locals {
  appPrefix = "tgr-${var.env}-${var.appName}"
  repositoryFront = "${var.appName}-front"
  repositoryBack = "${var.appName}-back"
  repositoryDirecciones = "${var.appName}-direcciones"
  direccionesElasticsearchDomainEndpoint = "${var.direccionesElasticsearchDomain =="" ? module.runtime.elasticsearchDirectionsDomainEndpoint: var.direccionesElasticsearchDomain}"
}

data "aws_region" "current" {}

module "runtime" {
  source = "./runtime"
  appPrefix = "${local.appPrefix}"
  appName = "${var.appName}"
  env = "${var.env}"
  frontAccount = "${var.frontAccount}"
  account = "${var.account}"
  appFrontSubdomain = "${var.appFrontSubdomain}"
  appFrontDomain = "${var.appFrontDomain}"
  cognitoPoolId = "${var.cognitoPoolId}"
  cognitoProviders = [
    "${var.cognitoProviders}"]
  cognitoReadAttributes = [
    "${var.cognitoReadAttributes}"]
  acmCertificateArn = "${var.acmCertificateArn}"
  route53ZoneId = "${var.route53ZoneId}"
  region = "${data.aws_region.current.name}"
}

module "governance" {
  source = "./governance"
  account = "${var.account}"
  appPrefix = "${local.appPrefix}"
  appName = "${var.appName}"
  env = "${var.env}"
  repositoryBack = "${local.repositoryBack}"
  repositoryFront = "${local.repositoryFront}"
  apiGatewayId = "${module.runtime.apiGatewayID}"
  serverlessPolicyArn = "${module.deployment.serverlessPolicyArn}"
  repositoryDirecciones = "${local.repositoryDirecciones}"
}

module "deployment" {
  source = "./deployment"
  account = "${var.account}"
  appPrefix = "${local.appPrefix}"
  appName = "${var.appName}"
  env = "${var.env}"
  apiGatewayID = "${module.runtime.apiGatewayID}"
  apiGatewayRootID = "${module.runtime.apiGatewayRootID}"
  cognitoPoolArn = "${var.cognitoPoolArn}"
  cognitoAuthorizeURL = "${var.cognitoAuthorizeURL}"
  cognitoLogoutURL = "${var.cognitoLogoutURL}"
  cognitoContribClientId = "${module.runtime.outContribClientID}"
  cognitoContribRedirectURI = "${module.runtime.contribRedirectUri}"
  cognitoContribLogoutURI = "${module.runtime.contribLogoutUri}"
  endpointApiElasticsearch = "${var.endpointApiElasticsearch}"
  endpointApiPublica = "${module.runtime.apigatewayEndpoint}"
  repositoryFront = "${local.repositoryFront}"
  repositoryBack = "${local.repositoryBack}"
  repositoryDirecciones = "${local.repositoryDirecciones}"
  tokensBucketID = "${module.runtime.tokensBucketID}"
  parseBucketID = "${module.runtime.parseBucketID}"
  frontBucketID = "${module.runtime.frontBucketID}"
  lambdaBackRoleArn = "${module.runtime.arnLambdaBackRole}"
  lambdaDireccionesRoleArn = "${module.runtime.arnLambdaDireccionesRole}"
  direccionesBucketID = "${module.runtime.direccionesBucketID}"
  elasticsearchEndpoint = "${local.direccionesElasticsearchDomainEndpoint}"
}

output "direccionesElasticsearchDomain" {
  value = "${module.runtime.elasticsearchDirectionsDomainEndpoint}"
}

terraform {
  backend "s3" {
    //bucket = "tgr-<env>-terraform-state"
    //key = "tgr-<env>-contribuciones-setup"
    encrypt = false
    region = "us-east-1"
  }
}