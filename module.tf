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

//variable "endpointApiPublica" {
//  type = "string"
//  default = "https://u3aeivcwv0.execute-api.us-east-1.amazonaws.com/dev"
//}

locals {
  appPrefix = "tgr-${var.env}-${var.appName}"
  repositoryFront = "${var.appName}-front"
  repositoryBack = "${var.appName}-back"
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
  cognitoProviders = ["${var.cognitoProviders}"]
  cognitoReadAttributes = ["${var.cognitoReadAttributes}"]
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
  apiGatewayId = "${module.runtime.outApiGatewayID}"
  serverlessPolicyArn = "${module.deployment.serverlessPolicyArn}"
}

module "deployment" {
  source = "./deployment"
  account = "${var.account}"
  appPrefix = "${local.appPrefix}"
  appName = "${var.appName}"
  env = "${var.env}"
  apiGatewayID = "${module.runtime.outApiGatewayID}"
  apiGatewayRootID = "${module.runtime.outApiGatewayRootID}"
  cognitoPoolArn = "${var.cognitoPoolArn}"
  cognitoAuthorizeURL = "${var.cognitoAuthorizeURL}"
  cognitoLogoutURL = "${var.cognitoLogoutURL}"
  cognitoContribClientId = "${module.runtime.outContribClientID}"
  cognitoContribRedirectURI = "${module.runtime.contribRedirectUri}"
  cognitoContribLogoutURI = "${module.runtime.contribLogoutUri}"
  endpointApiElasticsearch = "${var.endpointApiElasticsearch}"
  endpointApiPublica = "${module.runtime.outApigatewayEndpoint}"
  repositoryFront = "${local.repositoryFront}"
  repositoryBack = "${local.repositoryBack}"
  tokensBucketID = "${module.runtime.outTokensBucketID}"
  parseBucketID = "${module.runtime.outParseBucketID}"
  frontBucketID = "${module.runtime.outfrontBucketID}"
  arnLambdaRole = "${module.runtime.outArnLambdaRole}"
}

terraform {
  backend "s3" {
    //bucket = "tgr-<env>-terraform-state"
    //key = "tgr-<env>-contribuciones-setup"
    encrypt = false
    region = "us-east-1"
  }
}