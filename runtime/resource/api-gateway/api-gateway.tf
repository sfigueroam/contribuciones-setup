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

output "outApigatewayID" {
  value = "${aws_api_gateway_rest_api.apigatewayBack.id}"
}

output "outApigatewayRootID" {
  value = "${aws_api_gateway_rest_api.apigatewayBack.root_resource_id}"
}

output "outApigatewayEndpoint" {
  value = "https://${aws_api_gateway_rest_api.apigatewayBack.id}.execute-api.${var.region}.amazonaws.com/${var.env}"
}