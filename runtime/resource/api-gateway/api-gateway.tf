variable "appPrefix" {
  type = "string"
}

variable "region" {
  type = "string"
}

variable "env" {
  type = "string"
}

resource "aws_api_gateway_rest_api" "apigatewayBack" {
  name = "${var.appPrefix}-back"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

output "apigatewayID" {
  value = "${aws_api_gateway_rest_api.apigatewayBack.id}"
}

output "apigatewayRootID" {
  value = "${aws_api_gateway_rest_api.apigatewayBack.root_resource_id}"
}

output "apigatewayEndpoint" {
  value = "https://${aws_api_gateway_rest_api.apigatewayBack.id}.execute-api.${var.region}.amazonaws.com/${var.env}"
}