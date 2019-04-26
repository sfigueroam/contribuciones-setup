provider "aws" {
  alias = "prodDomainAccount"
  region = "us-east-1"
  version = "~> 1.57"
  assume_role {
    role_arn = "arn:aws:iam::${var.frontAccount}:role/tgr-prod-terraform-acceso-multi-cuenta"
    session_name = "terraform-prod"
    external_id = "tgr-terraform-multi-cuenta"
  }
}

variable "appPrefix" {
  type = "string"
}

variable "frontAccount" {
  type = "string"
  description = "Numero de la cuenta donde se configurará Route53 y Cloudfront."
}

variable "account" {
  type = "string"
}

variable "region" {
  type = "string"
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

module "runtimeCognitoAppClients" {
  source = "./resource/cognito"
  providers = {
    aws = "aws.prodDomainAccount"
  }
  appPrefix = "${var.appPrefix}"
  cloudfrontAlias = "${var.appFrontSubdomain}.${var.appFrontDomain}"
  cognitoReadAttributes = [
    "${var.cognitoReadAttributes}"]
  cognitoPoolID = "${var.cognitoPoolId}"
  cognitoProviders = [
    "${var.cognitoProviders}"]
}

module "runtimeS3Buckets" {
  source = "./resource/s3-bucket"
  appPrefix = "${var.appPrefix}"
  appName = "${var.appName}"
  env = "${var.env}"
}

module "runtimeApiGateway" {
  source = "./resource/api-gateway"
  appPrefix = "${var.appPrefix}"
  env = "${var.env}"
  region = "${var.region}"
}

module "runtimeCloudfront" {
  source = "./resource/cloudfront"
  providers = {
    aws = "aws.prodDomainAccount"
  }
  appName = "${var.appName}"
  env = "${var.env}"
  bucketWebsiteEndpoint = "${module.runtimeS3Buckets.frontBucketWebsiteEndpoint}"
  bucketName = "${module.runtimeS3Buckets.frontBucketID}"
  acmCertificateArn = "${var.acmCertificateArn}"
  alias = "${var.appFrontSubdomain}.${var.appFrontDomain}"
}

module "runtimeRoute53" {
  source = "./resource/route53"
  providers = {
    aws = "aws.prodDomainAccount"
  }
  cloudfrontDomainName = "${module.runtimeCloudfront.cloudfrontDomainName}"
  cloudfrontHostedZoneID = "${module.runtimeCloudfront.cloudfrontHostedZoneID}"
  subdomain = "${var.appFrontSubdomain}"
  domain = "${var.appFrontDomain}"
  route53ZoneID = "${var.route53ZoneId}"
}

module "runtimePermissionPolicy" {
  source = "./permission/policy"
  appName = "${var.appName}"
  appPrefix = "${var.appPrefix}"
  account = "${var.account}"
  frontBucketID = "${module.runtimeS3Buckets.frontBucketID}"
  parseBucketID = "${module.runtimeS3Buckets.parseBucketID}"
  tokensBucketID = "${module.runtimeS3Buckets.tokensBucketID}"
  direccionesBucketID = "${module.runtimeS3Buckets.direccionesBucketID}"
}

module "runtimePermissionRole" {
  source = "./permission/role"
  appPrefix = "${var.appPrefix}"
  appName = "${var.appName}"
  env = "${var.env}"
  cloudwatchPolicy = "${module.runtimePermissionPolicy.cloudwatchPolicyArn}"
  bucketsPolicy = "${module.runtimePermissionPolicy.bucketsPolicyArn}"
  ec2LambdaPolicy = "${module.runtimePermissionPolicy.ec2LambdaPolicyArn}"
  elasticsearchPolicy = "${module.runtimePermissionPolicy.elasticsearchPolicyArn}"
}

module "runtimeElasticSearch" {
  source = "./resource/elasticsearch"
  appPrefix = "${var.appPrefix}"
  appName = "${var.appName}"
  account = "${var.account}"
  env = "${var.env}"
}

module "runtimeS3Ec2" {
  source = "./resource/ec2"
  appPrefix = "${var.appPrefix}"
  appName = "${var.appName}"
  env = "${var.env}"
  DireccionesInsProfileEc2 = "${module.runtimePermissionRole.ec2InstanceProfileArn}"
}

output "outContribClientID" {
  value = "${module.runtimeCognitoAppClients.contribClientID}"
}

output "contribRedirectUri" {
  value = "${module.runtimeCognitoAppClients.contribRedirectUri}"
}

output "contribLogoutUri" {
  value = "${module.runtimeCognitoAppClients.contribLogoutUri}"
}

output "outCloufrontDomainName" {
  value = "${module.runtimeCloudfront.cloudfrontDomainName}"
}

output "clouFrontHostedZoneID" {
  value = "${module.runtimeCloudfront.cloudfrontHostedZoneID}"
}

output "arnLambdaBackRole" {
  value = "${module.runtimePermissionRole.lambdaBackRoleArn}"
}

output "arnLambdaDireccionesRole" {
  value = "${module.runtimePermissionRole.lambdaDireccionesRoleArn}"
}

output "apiGatewayID" {
  value = "${module.runtimeApiGateway.apigatewayID}"
}

output "apiGatewayRootID" {
  value = "${module.runtimeApiGateway.apigatewayRootID}"
}

output "apigatewayEndpoint" {
  value = "${module.runtimeApiGateway.apigatewayEndpoint}"
}

output "frontBucketID" {
  value = "${module.runtimeS3Buckets.frontBucketID}"
}

output "parseBucketID" {
  value = "${module.runtimeS3Buckets.parseBucketID}"
}

output "tokensBucketID" {
  value = "${module.runtimeS3Buckets.tokensBucketID}"
}

output "direccionesBucketID" {
  value = "${module.runtimeS3Buckets.direccionesBucketID}"
}

output "elasticsearchDirectionsDomainEndpoint" {
  value = "${module.runtimeElasticSearch.elasticsearchDirectionsDomainEndpoint}"
}
