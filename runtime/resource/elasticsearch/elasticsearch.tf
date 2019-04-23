variable "appPrefix" {
  type="string"
}
variable "appName" {
  type="string"
}
variable "env" {
  type="string"
}
variable "account" {
  type="string"
}

data "aws_iam_policy_document" "elasticSearchAccessDataPolicy" {
  statement {
    actions=["es:*"]
    principals {
      identifiers=["AWS" ]
      type="*"
    }
    resources=["arn:aws:es:us-east-1:${var.account}:domain/${var.appPrefix}/*" ]
    condition {
      test="IpAddress"
      variable="aws:SourceIp"
      values=["163.247.65.3"]
    }
  }
}

resource "aws_elasticsearch_domain" "elasticsearchDirectionsDomain" {
  domain_name="${var.appPrefix}"
  elasticsearch_version="6.3"
  access_policies="${data.aws_iam_policy_document.elasticSearchAccessDataPolicy.json}"

  advanced_options {
    "rest.action.multi.allow_explicit_index"="true"
  }

  cluster_config {
    instance_type="t2.medium.elasticsearch"
    instance_count="2"
  }
  ebs_options {
    ebs_enabled="true"
    volume_type="gp2"
    volume_size="35"
  }

  snapshot_options {
    automated_snapshot_start_hour=23
  }

  tags={
    Application="${var.appName}"
    Env="${var.env}"
  }
  lifecycle {
    ignore_changes  = ["access_policies"]
  }

}

output "elasticsearchDirectionsDomainArn" {
  value="${aws_elasticsearch_domain.elasticsearchDirectionsDomain.arn}"
}

output "elasticsearchDirectionsDomainEndpoint" {
  value="${aws_elasticsearch_domain.elasticsearchDirectionsDomain.endpoint}"
}
