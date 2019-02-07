variable "subdomain" {
  type = "string"
}

variable "domain" {
  type = "string"
}

variable "route53-zone-id" {
  type = "string"
}

variable "cloudfront-domain-name" {
  type = "string"
}

variable "cloudfront-hosted-zone-id" {
  type = "string"
}

resource "aws_route53_record" "subdomain" {
  zone_id = "${var.route53-zone-id}"
  name = "${var.subdomain}.${var.domain}"
  type = "A"

  alias {
    name = "${var.cloudfront-domain-name}"
    zone_id = "${var.cloudfront-hosted-zone-id}"
    evaluate_target_health = true
  }
}