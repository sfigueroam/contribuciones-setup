variable "appPrefix" {
  type = "string"
}

resource "aws_api_gateway_rest_api" "api_gateway_back" {
  name = "${var.appPrefix}-back"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

output "out_api_gateway_id" {
  value = "${aws_api_gateway_rest_api.api_gateway_back.id}"
}

output "out_api_gateway_root_id" {
  value = "${aws_api_gateway_rest_api.api_gateway_back.root_resource_id}"
}