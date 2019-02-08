provider "aws" {
  region = "us-east-1"
}

variable "env" {
  type = "string"
  description = "El ambiente donde se trabaja dev,qa,prod,lab."
}

variable "appName" {
  type = "string"
  description = "Nombre de la aplicacion."
}

locals {
  localPrefix = "tgr-${var.env}-${var.appName}"
}

module "resource_elasticsearch" {
  source = "./resource/elasticsearch"
  appPrefix = "${local.localPrefix}"
  appName = "${var.appName}"
  env = "${var.env}"
}

module "resource_s3" {
  source = "./resource/s3-bucket"
  appPrefix = "${local.localPrefix}"
  appName = "${var.appName}"
  env = "${var.env}"
  /*
    output "out_s3_bucket_parse_name"
    output "out_s3_bucket_token_name"
    output "out_s3_bucket_front_name"
    output "out_s3_bucket_front_domain_name"
  */
}

module "resource_api_gateway" {
  source = "./resource/api-gateway"
  appPrefix = "${local.localPrefix}"

  /*
  output "out_api_gateway_id"
  output "out_api_gateway_root_id"
  */
}

/*
module "resource_cloud_front" {
  source              = "./resource/cloud-front"
  appName             = "${var.appName}"
  env                 = "${var.env}"
  bucketName          = "${module.resource_s3.out_s3_bucket_front_name}"
  bucketDomainName    = "${module.resource_s3.out_s3_bucket_front_domain_name}"
}
*/


terraform {
  backend "s3" {
    //bucket = "tgr-<env>-terraform-state"
    //key = "tgr-<env>-contribuciones-setup"
    encrypt = false
    region = "us-east-1"
  }
}