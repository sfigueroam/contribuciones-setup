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

resource "aws_cognito_user_pool_client" "appClient" {
  name = "${var.appPrefix}"

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

output "contribClientID" {
  value = "${aws_cognito_user_pool_client.appClient.id}"
}

output "contribRedirectUri" {
  value = "${aws_cognito_user_pool_client.appClient.callback_urls[0]}"
}

output "contribLogoutUri" {
  value = "${aws_cognito_user_pool_client.appClient.logout_urls[0]}"
}