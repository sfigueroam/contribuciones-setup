variable "appPrefix" {
  type = "string"
}
variable "appName" {
  type = "string"
}
variable "env" {
  type = "string"
}

resource "aws_elasticsearch_domain" "es_domain" {
  domain_name = "${var.appPrefix}"
  elasticsearch_version = "6.3"

  cluster_config {
    instance_type = "m3.medium.elasticsearch"
    instance_count = 2
  }

  ebs_options {
    ebs_enabled = true
    volume_type = "gp2"
    volume_size = "70"
  }
  snapshot_options {
    automated_snapshot_start_hour = 23
  }

  tags = {
    Application = "${var.appName}"
    Env = "${var.env}"
  }
}

output "out_es_domain_arn" {
  value = "${aws_elasticsearch_domain.es_domain.arn}"
}
