provider "aws" {
  region = "us-east-1"
  version = "~> 1.57"
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

variable "cognitoProviders" {
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

data "aws_ssm_parameter" "kms_key_arn" {
  name = "/tgr/common/kms-key-arn"
}

data "aws_ssm_parameter" "acm_certificate_arn" {
  name = "/tgr/common/acm-certificate-arn"
}

data "aws_ssm_parameter" "front_domain" {
  name = "/tgr/common/front-domain"
}

data "aws_ssm_parameter" "zone_id_domain" {
  name = "/tgr/common/zone-id-domain"
}

data "aws_ssm_parameter" "cognito_pool_id" {
  name = "/tgr/common/cognito-pool-id"
}

data "aws_ssm_parameter" "cognito_pool_arn" {
  name = "/tgr/common/cognito-pool-arn"
}

data "aws_ssm_parameter" "cognito_logout_url" {
  name = "/tgr/common/cognito-logout-url"
}

data "aws_ssm_parameter" "cognito_authorize_url" {
  name = "/tgr/common/cognito-authorize-url"
}

data "aws_ssm_parameter" "pipeline_bucket_name" {
  name = "/tgr/common/pipeline-bucket-name"
}

data "aws_ssm_parameter" "pipeline_role_arn" {
  name = "/tgr/common/pipeline-role-arn"
}

data "aws_ssm_parameter" "build_role_arn" {
  name = "/tgr/common/build-role-arn"
}

data "aws_ssm_parameter" "repository_role_arn" {
  name = "/tgr/common/repository-role-arn"
}

data "aws_ssm_parameter" "codecommit_account" {
  name = "/tgr/common/codecommit-account"
}

data "aws_region" "current" {}
data "aws_caller_identity" "get_account" {}

locals {
  appPrefix = "tgr-${var.env}-${var.appName}"
  repositoryFront = "${var.appName}-front"
  repositoryBack = "${var.appName}-back"
  repositoryDirecciones = "${var.appName}-direcciones"
  direccionesElasticsearchDomainEndpoint = "${var.direccionesElasticsearchDomain =="" ? module.runtime.elasticsearchDirectionsDomainEndpoint: var.direccionesElasticsearchDomain}"
  branchMap = {
    "prod" = "master"
    "stag" = "staging"
    "dev" = "develop"
    "env" = "release"
    "qa" = "release"
    "env-0529" = "release"
  }
}

module "runtime" {
  source = "./runtime"
  appPrefix = "${local.appPrefix}"
  appName = "${var.appName}"
  env = "${var.env}"
  frontAccount = "${var.frontAccount}"
  account = "${data.aws_caller_identity.get_account.account_id}"
  appFrontSubdomain = "${var.appFrontSubdomain}"
  appFrontDomain = "${data.aws_ssm_parameter.front_domain.value}"
  cognitoPoolId = "${data.aws_ssm_parameter.cognito_pool_id.value}"
  cognitoProviders = [
    "${var.cognitoProviders}"]
  acmCertificateArn = "${data.aws_ssm_parameter.acm_certificate_arn.value}"
  route53ZoneId = "${data.aws_ssm_parameter.zone_id_domain.value}"
  region = "${data.aws_region.current.name}"
}

module "governance" {
  source = "./governance"
  account = "${data.aws_caller_identity.get_account.account_id}"
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
  account = "${data.aws_caller_identity.get_account.account_id}"
  appPrefix = "${local.appPrefix}"
  appName = "${var.appName}"
  env = "${var.env}"
  apiGatewayID = "${module.runtime.apiGatewayID}"
  apiGatewayRootID = "${module.runtime.apiGatewayRootID}"
  cognitoPoolArn = "${data.aws_ssm_parameter.cognito_pool_arn.value}"
  cognitoAuthorizeURL = "${data.aws_ssm_parameter.cognito_authorize_url.value}"
  cognitoLogoutURL = "${data.aws_ssm_parameter.cognito_logout_url.value}"
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
  beneficiosTableName = "${module.runtime.beneficiosTableName}"
  buildRoleArn = "${data.aws_ssm_parameter.build_role_arn.value}"
  pipelineBucketName = "${data.aws_ssm_parameter.pipeline_bucket_name.value}"
  pipelineRoleArn = "${data.aws_ssm_parameter.pipeline_role_arn.value}"
  roleArnGetCodecommit = "${data.aws_ssm_parameter.repository_role_arn.value}"
  branchMap = "${local.branchMap}"
  kmsKeyArn = "${data.aws_ssm_parameter.kms_key_arn.value}"
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