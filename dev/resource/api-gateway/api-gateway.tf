variable "appPrefix" {
  type = "string"
}

variable "region" {
  type = "string"
}

variable "env" {
  type = "string"
}

resource "aws_api_gateway_rest_api" "api_gateway_back" {
  name = "${var.appPrefix}-back"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

output "apiGatewayId" {
  value = "${aws_api_gateway_rest_api.api_gateway_back.id}"
}

output "apiGatewayRootId" {
  value = "${aws_api_gateway_rest_api.api_gateway_back.root_resource_id}"
}

output "endpoint" {
  value = "https://${aws_api_gateway_rest_api.api_gateway_back.id}.execute-api.${var.region}.amazonaws.com/${var.env}"
}
