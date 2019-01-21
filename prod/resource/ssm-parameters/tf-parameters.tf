variable "appName" {
  type        = "string"
}

variable "env" {
  type        = "string"
}

variable "serviceName" {
  description = "indicar el nombre del servicio que usa los parametros"
  type        = "string"
  default     = "ws-tierra"
}

variable "bucketTokens" {
  type        = "string"
}

variable "bucketParse" {
  type        = "string"
}

variable "roleArnServerlessFile" {
  type        = "string"
}

locals {
  paramPrefix = "/tgr/${var.env}/${var.appName}/${var.serviceName}"
}

resource "aws_ssm_parameter" "ssm_parameter_1" {
  name        = "${local.paramPrefix}/bucket"
  type        = "String"
  value       = "${var.bucketTokens}" // en devtest se llama tgr-tokens-proxies-poc-dev

  tags = {
    Env 		    = "${var.env}"
	  Application = "${var.appName}"
	  Owner		    = "dsaldias"
  }
}

resource "aws_ssm_parameter" "ssm_parameter_2" {
  name        = "${local.paramPrefix}/role"
  type        = "String"
  value       = "${var.roleArnServerlessFile}" // arn:aws:iam::080540609156:role/PatagoniaDevRole

  tags = {
    Env 		    = "${var.env}"
    Application = "${var.appName}"
    Owner		    = "dsaldias"
  }
}

resource "aws_ssm_parameter" "ssm_parameter_3" {
  name        = "${local.paramPrefix}/bucket-parse"
  type        = "String"
  value       = "${var.bucketParse}" // en devtest se llama tgr-parse-proxies-poc-dev

  tags = {
    Env 		    = "${var.env}"
    Application = "${var.appName}"
    Owner		    = "dsaldias"
  }
}

resource "aws_ssm_parameter" "ssm_parameter_4" {
  name        = "${local.paramPrefix}/cliente-id"
  type        = "StringList"
  value       = "OauthClientesDatosBasicosClient, OauthClientesCorreoClient, OauthTgrClientesCuentasClient, OauthTgrClientesDireccionClient, OauthClientesTelefonoClient, OauthBienRaizRolinClient, OauthRecuperaDeudaRolClient, OauthTgrSuscriptorWsClient, OauthTablasGeneralesRsClient, OauthRcPagosConsultasTgrClient"

  tags = {
    Env 		    = "${var.env}"
    Application = "${var.appName}"
    Owner		    = "dsaldias"
  }
}

resource "aws_ssm_parameter" "ssm_parameter_5" {
  name        = "${local.paramPrefix}/cliente-secret"
  type        = "StringList"
  value       = "TGR.passw0rd, TGR.passw0rd, TGR.passw0rd, TGR.passw0rd, TGR.passw0rd, TGR.passw0rd, TGR.passw0rd, TGR.passw0rd, TGR.passw0rd, TGR.passw0rd"

  tags = {
    Env 		    = "${var.env}"
    Application = "${var.appName}"
    Owner	  	  = "dsaldias"
  }
}

resource "aws_ssm_parameter" "ssm_parameter_6" {
  name        = "${local.paramPrefix}/grant-type"
  type        = "String"
  value       = "client_credentials"

  tags = {
    Env 		    = "${var.env}"
    Application = "${var.appName}"
    Owner		    = "dsaldias"
  }
}

resource "aws_ssm_parameter" "ssm_parameter_7" {
  name        = "${local.paramPrefix}/host"
  type        = "String"
  value       = "wstest.tesoreria.cl"

  tags = {
    Env 		    = "${var.env}"
    Application = "${var.appName}"
    Owner		    = "dsaldias"
  }
}

resource "aws_ssm_parameter" "ssm_parameter_8" {
  name        = "${local.paramPrefix}/key-parse"
  type        = "String"
  value       = "parse.json"

  tags = {
    Env 		    = "${var.env}"
    Application = "${var.appName}"
    Owner		    = "dsaldias"
  }
}

resource "aws_ssm_parameter" "ssm_parameter_9" {
  name        = "${local.paramPrefix}/port"
  type        = "String"
  value       = "443"

  tags = {
    Env 		    = "${var.env}"
    Application = "${var.appName}"
    Owner		    = "dsaldias"
  }
}
