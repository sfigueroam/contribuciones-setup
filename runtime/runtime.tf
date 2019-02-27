provider "aws" {
  alias = "prodDomainAccount"
  region = "us-east-1"
  version = "~> 1.57"
  assume_role {
    role_arn     = "arn:aws:iam::${var.frontAccount}:role/tgr-prod-terraform-acceso-multi-cuenta"
    session_name = "terraform-prod"
    external_id  = "tgr-terraform-multi-cuenta"
  }
}

variable "appPrefix" {
  type = "string"
}

variable "frontAccount" {
  type = "string"
  description = "Numero de la cuenta donde se configurará Route53 y Cloudfront."
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
  source = "./resource/cognito/app-clients"
  appPrefix = "${var.appPrefix}"
  cloudfrontAlias = "${var.appFrontSubdomain}.${var.appFrontDomain}"
  cognitoReadAttributes = ["${var.cognitoReadAttributes}"]
  cognitoPoolID = "${var.cognitoPoolId}"
  cognitoProviders = ["${var.cognitoProviders}"]
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
  bucketWebsiteEndpoint = "${module.runtimeS3Buckets.outBucketFrontWebsiteEndpoint}"
  bucketName = "${module.runtimeS3Buckets.outFrontBucketID}"
  acmCertificateArn = "${var.acmCertificateArn}"
  alias = "${var.appFrontSubdomain}.${var.appFrontDomain}"
}

module "runtimeRoute53" {
  source = "./resource/route53"
  providers = {
    aws = "aws.prodDomainAccount"
  }
  cloudfrontDomainName = "${module.runtimeCloudfront.outCloudfrontDomainName}"
  cloudfrontHostedZoneID = "${module.runtimeCloudfront.outCloudfronthostedZoneID}"
  subdomain = "${var.appFrontSubdomain}"
  domain = "${var.appFrontDomain}"
  route53ZoneID="${var.route53ZoneId}"
}

module "runtimePermissionPolicy" {
  source = "./permission/policy"
  prefix = "${var.appPrefix}"
  bucketNameFront = "${module.runtimeS3Buckets.outFrontBucketID}"
  bucketNameParse = "${module.runtimeS3Buckets.outParseBucketId}"
  bucketNameTokens = "${module.runtimeS3Buckets.outTokensBucketId}"
}

module "runtimePermissionRole" {
  source = "./permission/role"
  prefix = "${var.appPrefix}"
  appName = "${var.appName}"
  env = "${var.env}"
  cloudwatchPolicy = "${module.runtimePermissionPolicy.outArnCloudwatchPolicy}"
  bucketPolicy = "${module.runtimePermissionPolicy.outArnBucketPolicy}"
}


output "outContribClientID" {
  value = "${module.runtimeCognitoAppClients.outContribClientID}"
}

output "outContribRedirectUri" {
  value = "${module.runtimeCognitoAppClients.outContribRedirectUri}"
}

output "outCloufrontDomainName" {
  value = "${module.runtimeCloudfront.outCloudfrontDomainName}"
}

output "outClouFrontHostedZoneID" {
  value = "${module.runtimeCloudfront.outCloudfronthostedZoneID}"
}

output "outArnLambdaRole" {
  value = "${module.runtimePermissionRole.outArnLambdaRole}"
}

output "outApiGatewayID" {
  value = "${module.runtimeApiGateway.outApigatewayID}"
}

output "outApiGatewayRootID" {
  value = "${module.runtimeApiGateway.outApigatewayRootID}"
}

output "outApigatewayEndpoint" {
  value = "${module.runtimeApiGateway.outApigatewayEndpoint}"
}

output "outfrontBucketID" {
  value = "${module.runtimeS3Buckets.outFrontBucketID}"
}

output "outParseBucketID" {
  value = "${module.runtimeS3Buckets.outParseBucketId}"
}

output "outTokensBucketID" {
  value = "${module.runtimeS3Buckets.outTokensBucketId}"
}