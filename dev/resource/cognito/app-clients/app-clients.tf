variable "prefix" {
  type = "string"
}

variable "cognito-pool-id" {
  type = "string"
}

variable "cloudfront-alias" {
  type = "string"
}

variable "cognito-providers" {
  type = "list"
}

variable "cognito-read-attributes" {
  type = "list"
}


resource "aws_cognito_user_pool_client" "contribuciones_client" {
  name = "${var.prefix}-contrib"

  user_pool_id = "${var.cognito-pool-id}"

  callback_urls = [
    "https://${var.cloudfront-alias}/login"
  ]

  logout_urls = [
    "https://${var.cloudfront-alias}/logout"
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

  supported_identity_providers = "${var.cognito-providers}"

  #read_attributes = "${var.cognito-read-attributes}"
  #[
  #  "custom:clave-unica:run",
  #  "custom:clave-unica:name"]
}

resource "aws_cognito_user_pool_client" "cuenta_client" {
  name = "${var.prefix}-cuenta"

  user_pool_id = "${var.cognito-pool-id}"

  callback_urls = [
    "https://${var.cloudfront-alias}/login"
  ]

  logout_urls = [
    "https://${var.cloudfront-alias}/logout"
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

  supported_identity_providers = "${var.cognito-providers}"

  #read_attributes = "${var.cognito-read-attributes}"
  #[
  #  "custom:clave-unica:run",
  #  "custom:clave-unica:name"]
}

output "contrib-client-id" {
  value = "${aws_cognito_user_pool_client.contribuciones_client.id}"
}

output "contrib-redirect-uri" {
  value = "${aws_cognito_user_pool_client.contribuciones_client.callback_urls[0]}"
}