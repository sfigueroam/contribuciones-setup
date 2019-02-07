provider "aws" {
  region = "us-east-1"
  version = "~> 1.57"
}

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

variable "cognitoProviders" {
  type = "list"
}

variable "cognitoReadAttributes" {
  type = "list"
}

variable "endpoint-api-elasticsearch" {
  type = "string"
  default = "https://w2jmtnip5c.execute-api.us-east-1.amazonaws.com/dev"
}

variable "endpoint-api-publica" {
  type = "string"
  default = "https://u3aeivcwv0.execute-api.us-east-1.amazonaws.com/dev"
}

locals {
  localPrefix = "tgr-${var.env}-${var.appName}"
  cBuildRoleBack = "arn:aws:iam::${var.account}:role/tgr-${var.env}-project-setup-codebuild"
  cBuildRoleFront = "arn:aws:iam::${var.account}:role/tgr-${var.env}-project-setup-codebuild"
  cPipelineRoleBack = "arn:aws:iam::${var.account}:role/tgr-${var.env}-project-setup-codepipeline"
  cPipelineRoleFront = "arn:aws:iam::${var.account}:role/tgr-${var.env}-project-setup-codepipeline"
  cPipelineBucket = "tgr-${var.env}-codepipelines"
  repositoryFront = "${var.appName}-front"
}

/*
module "resource_elasticsearch" {
  source = "./resource/elasticsearch"
  appPrefix = "${local.localPrefix}"
  appName = "${var.appName}"
  env = "${var.env}"
}
*/

module "s3-bucket-front" {
  source = "./resource/s3-bucket"
  appPrefix = "${local.localPrefix}"
  appName = "${var.appName}"
  env = "${var.env}"
}

module "resource_api_gateway" {
  source = "./resource/api-gateway"
  appPrefix = "${local.localPrefix}"
}

module "resource_cloudfront" {
  source = "./resource/cloudfront"
  appName = "${var.appName}"
  env = "${var.env}"
  bucketWebsiteEndpoint = "${module.s3-bucket-front.s3-bucket-front-website-endpoint}"
  bucketName = "${module.s3-bucket-front.id}"
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
  prefix = "${local.localPrefix}"
}

module "permission_role" {
  source = "./permission/role"
  prefix = "${local.localPrefix}"
  appName = "${var.appName}"
  env = "${var.env}"
  cloudwatchPolicy = "${module.permission_policy.out_arn_policy_cloudwatch}"
}

module "cognito_app-clients" {
  source = "./resource/cognito/app-clients"
  prefix = "${local.localPrefix}"
  cloudfront-alias = "${var.appFrontSubdomain}.${var.appFrontDomain}"
  cognito-pool-id = "${var.cognitoPoolId}"
  cognito-providers = ["${var.cognitoProviders}"]
  cognito-read-attributes = ["${var.cognitoReadAttributes}"]
}

module "codepipeline_front" {
  source = "./codepipeline/front"
  prefix = "${local.localPrefix}"
  appName = "${var.appName}"
  env = "${var.env}"
  repository = "${local.repositoryFront}"
  cBuildRole = "${local.cBuildRoleFront}"
  cPipelineRole = "${local.cPipelineRoleFront}"
  cPipelineBucket = "${local.cPipelineBucket}"
  bucket-front-id = "${module.s3-bucket-front.id}"
  endpoint-api-elasticsearch = "${var.endpoint-api-elasticsearch}"
  endpoint-api-publica = "${var.endpoint-api-publica}"
}

terraform {
  backend "s3" {
    //bucket = "tgr-<env>-terraform-state"
    //key = "tgr-<env>-contribuciones-setup"
    encrypt = false
    region = "us-east-1"
  }
}