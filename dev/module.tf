provider "aws" {
  region = "us-east-1"
  version = "~> 1.57"
}

data "aws_region" "current" {}

variable "account" {
  type = "string"
  description = "Numero de la cuenta."
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
  cBuildRoleBack = "arn:aws:iam::${var.account}:role/tgr-${var.env}-project-setup-codebuild"
  cBuildRoleFront = "arn:aws:iam::${var.account}:role/tgr-${var.env}-project-setup-codebuild"
  cPipelineRoleBack = "arn:aws:iam::${var.account}:role/tgr-${var.env}-project-setup-codepipeline"
  cPipelineRoleFront = "arn:aws:iam::${var.account}:role/tgr-${var.env}-project-setup-codepipeline"
  cPipelineBucket = "tgr-${var.env}-codepipelines"
  repositoryFront = "${var.appName}-front"
  repositoryBack = "${var.appName}-back"
}

/*
module "resource_elasticsearch" {
  source = "./resource/elasticsearch"
  appPrefix = "${local.localPrefix}"
  appName = "${var.appName}"
  env = "${var.env}"
}
*/

module "s3_buckets" {
  source = "./resource/s3-bucket"
  appPrefix = "${local.appPrefix}"
  appName = "${var.appName}"
  env = "${var.env}"
}

module "api-gateway" {
  source = "./resource/api-gateway"
  appPrefix = "${local.appPrefix}"
  env = "${var.env}"
  region = "${data.aws_region.current.name}"
}

module "resource_cloudfront" {
  source = "./resource/cloudfront"
  appName = "${var.appName}"
  env = "${var.env}"
  bucketWebsiteEndpoint = "${module.s3_buckets.website-endpoint}"
  bucketName = "${module.s3_buckets.websiteId}"
  acm-certificate-arn = "${var.acmCertificateArn}"
  alias = "${var.appFrontSubdomain}.${var.appFrontDomain}"
}

module "resource-route53" {
  source = "./resource/route53"
  cloudfront-domain-name = "${module.resource_cloudfront.domain-name}"
  cloudfront-hosted-zone-id = "${module.resource_cloudfront.hosted-zone-id}"
  subdomain = "${var.appFrontSubdomain}"
  domain = "${var.appFrontDomain}"
  "route53-zone-id" = "${var.route53ZoneId}"
}

module "permission_policy" {
  source = "./permission/policy"
  prefix = "${local.appPrefix}"
  s3Arns = ["${module.s3_buckets.websiteArn}", "${module.s3_buckets.tokensArn}", "${module.s3_buckets.parseArn}","${module.s3_buckets.websiteArn}/*", "${module.s3_buckets.tokensArn}/*", "${module.s3_buckets.parseArn}/*"]
}

module "permission_role" {
  source = "./permission/role"
  prefix = "${local.appPrefix}"
  appName = "${var.appName}"
  env = "${var.env}"
  cloudwatchPolicy = "${module.permission_policy.out_arn_policy_cloudwatch}"
  s3Policy = "${module.permission_policy.out_arn_policy_s3}"
}

module "cognito_app-clients" {
  source = "./resource/cognito/app-clients"
  prefix = "${local.appPrefix}"
  cloudfront-alias = "${var.appFrontSubdomain}.${var.appFrontDomain}"
  cognito-pool-id = "${var.cognitoPoolId}"
  cognito-providers = [
    "${var.cognitoProviders}"]
  cognito-read-attributes = [
    "${var.cognitoReadAttributes}"]
}

module "codepipeline_front" {
  source = "./codepipeline/front"
  appPrefix = "${local.appPrefix}"
  appName = "${var.appName}"
  env = "${var.env}"
  repository = "${local.repositoryFront}"
  cBuildRole = "${local.cBuildRoleFront}"
  cPipelineRole = "${local.cPipelineRoleFront}"
  cPipelineBucket = "${local.cPipelineBucket}"
  bucket-front-id = "${module.s3_buckets.websiteId}"
  endpoint-api-elasticsearch = "${var.endpointApiElasticsearch}"
  endpoint-api-publica = "${module.api-gateway.endpoint}"
  cognitoAuthorizeURL = "${var.cognitoAuthorizeURL}"
  cognitoContribClientId = "${module.cognito_app-clients.contrib-client-id}"
  cognitoContribRedirectURI = "${module.cognito_app-clients.contrib-redirect-uri}"
}

module "codepipeline_back" {
  source = "./codepipeline/back"
  env = "${var.env}"
  appName = "${var.appName}"
  appPrefix = "${local.appPrefix}"
  apiGatewayID = "${module.api-gateway.apiGatewayId}"
  apiGatewayRootID = "${module.api-gateway.apiGatewayRootId}"
  bucketTokens = "${module.s3_buckets.tokensId}"
  bucketParse = "${module.s3_buckets.parseId}"
  cBuildRole = "${local.cBuildRoleBack}"
  cPipelineBucket = "${local.cPipelineBucket}"
  cPipelineRole = "${local.cPipelineRoleBack}"
  lambdaRoleArn = "${module.permission_role.lambdaRoleArn}"
  repository = "${local.repositoryBack}"
  cognitoPoolArn = "${var.cognitoPoolArn}"
}

terraform {
  backend "s3" {
    //bucket = "tgr-<env>-terraform-state"
    //key = "tgr-<env>-contribuciones-setup"
    encrypt = false
    region = "us-east-1"
  }
}