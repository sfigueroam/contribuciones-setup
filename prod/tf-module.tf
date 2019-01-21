provider "aws" {
  region = "us-east-1"
}
variable "account" {
  type = "string"
  description = "Numero de la cuenta."
}
variable "env" {
  type        = "string"
  description = "El ambiente donde se trabaja dev,qa,prod,lab."
}
variable "appName" {
  type        = "string"
  description = "Nombre de la aplicacion."
}
variable "kmsKey" {
  type        = "string"
  description = "Key con la cual se encripta y desencripta el codigo de codecommit para code pipeline."
}
variable "repositoryName" {
  type        = "string"
  description = "Nombre del repositorio code commit donde se obtienen los fuentes."
}
variable "cPipelineBucket" {
  type        = "string"
  description = "Nombre del bucket s3 donde codepipeline guarda los fuentes de code commit."
}


locals {
  localPrefix = "tgr-${var.env}-${var.appName}"
  cBuildRoleServerless    = "arn:aws:iam::${var.account}:role/tgr-${var.env}-${var.appName}-setup-codebuild"
  cPipelineRoleServerless = "arn:aws:iam::${var.account}:role/tgr-${var.env}-${var.appName}-setup-codepipeline"
  cBuildRoleAngular       = "arn:aws:iam::${var.account}:role/tgr-${var.env}-${var.appName}-setup-codebuild"
  cPipelineRoleAngular    = "arn:aws:iam::${var.account}:role/tgr-${var.env}-${var.appName}-setup-codepipeline"
}

module "permission_role" {
  source  = "./permission/role"
  prefix     = "${local.mLocalPrefix}"
  /*
    output "out_arn_role_lambda"
  */
}

module "resource_s3" {
  source     = "./resource/s3-bucket"
  prefix     = "${local.mLocalPrefix}"
  appName    = "${var.appName}"
  env        = "${var.env}"
  /*
    output "out_s3_bucket_parse_name"
    output "out_s3_bucket_token_name"
    output "out_s3_bucket_front_domain_name"
  */
}

module "resource_ssm_parameters" {
  source                = "./resource/ssm-parameters"
  appName               = "${var.appName}"
  env                   = "${var.env}"
  serviceName           = "ws-tierra"
  bucketTokens          = "${module.resource_s3.out_s3_bucket_token_name}"
  bucketParse           = "${module.resource_s3.out_s3_bucket_parse_name}"
  roleArnServerlessFile = "${module.permission_role.out_arn_role_lambda}" //rol para archivo serverless.yml "${module.role.out_arn_role_lambda}"
}

module "resource_api_gateway" {
  source     = "./resource/api-gateway"
  prefix     = "${local.mLocalPrefix}" 
  /*
    output "out_api_gateway_id"
    output "out_api_gateway_root_id"
  */
}

module "codepipeline_serverless" {
  source  = "./codepipeline/serverless"
  prefix          = "${local.localPrefix}"
  appName         = "${var.appName}"
  env             = "${var.env}"
  roleArn         = "${module.permission_role.out_arn_role_lambda}" //rol para archivo serverless.yml "${module.role.out_arn_role_lambda}"
  kmsKey 	        = "${var.kmsKey}"
  repository      = "${var.repositoryName}"
  cBuildRole      = "${local.cBuildRoleServerless}"
  cPipelineRole   = "${local.cPipelineRoleServerless}"
  cPipelineBucket = "${local.cBuildRoleServerless}"
}

module "codepipeline_angular" {
  source  = "./codepipeline/angular"
  prefix          = "${local.localPrefix}"
  appName         = "${var.appName}"
  env             = "${var.env}"
  kmsKey 	        = "${var.kmsKey}"
  repository      = "${var.repositoryName}"
  cBuildRole      = "${local.cBuildRoleAngular}"
  cPipelineRole   = "${local.cPipelineRoleAngular}"
  cPipelineBucket = "${local.cBuildRoleServerless}"
}




/*
terraform {
  backend "s3" {
    bucket = "tgr-dev-codebuild-terraform-state"
	  key = "terraform.state.boton-pago"
	  encrypt = false
    region = "us-east-1"
 }
}
*/