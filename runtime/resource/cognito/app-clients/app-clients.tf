variable "appPrefix" {
  type = "string"
}

variable "cognitoPoolID" {
  type = "string"
}

variable "cloudfrontAlias" {
  type = "string"
}

variable "cognitoProviders" {
  type = "list"
}

variable "cognitoReadAttributes" {
  type = "list"
}


resource "aws_cognito_user_pool_client" "contribucionesClient" {
  name = "${var.appPrefix}-contrib"

  user_pool_id = "${var.cognitoPoolID}"

  callback_urls = [
    "https://${var.cloudfrontAlias}/login"
  ]

  logout_urls = [
    "https://${var.cloudfrontAlias}/logout"
  ]

  allowed_oauth_flows = [
    "implicit"
  ]

  allowed_oauth_scopes = [
    "email",
    "openid",
    "profile"
  ]

  allowed_oauth_flows_user_pool_client = true

  supported_identity_providers = "${var.cognitoProviders}"

  #read_attributes = "${var.cognito-read-attributes}"
  #[
  #  "custom:clave-unica:run",
  #  "custom:clave-unica:name"]
}

resource "aws_cognito_user_pool_client" "cuentaClient" {
  name = "${var.appPrefix}-cuenta"

  user_pool_id = "${var.cognitoPoolID}"

  callback_urls = [
    "https://${var.cloudfrontAlias}/login"
  ]

  logout_urls = [
    "https://${var.cloudfrontAlias}/logout"
  ]

  allowed_oauth_flows = [
    "implicit"
  ]

  allowed_oauth_scopes = [
    "email",
    "openid",
    "profile"
  ]

  allowed_oauth_flows_user_pool_client = true

  supported_identity_providers = "${var.cognitoProviders}"

  #read_attributes = "${var.cognito-read-attributes}"
  #[
  #  "custom:clave-unica:run",
  #  "custom:clave-unica:name"]
}

output "outContribClientID" {
  value = "${aws_cognito_user_pool_client.contribucionesClient.id}"
}

output "outContribRedirectUri" {
  value = "${aws_cognito_user_pool_client.contribucionesClient.callback_urls[0]}"
}