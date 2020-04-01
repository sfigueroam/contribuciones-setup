variable "appPrefix" {
  type = "string"
}

variable "env" {
  type = "string"
}

variable "appName" {
  type = "string"
}

resource "aws_dynamodb_table" "dynamodb-roles-exclusion-table" {
  name = "${var.appPrefix}-roles-covid19"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "rol"

  attribute {
    name = "rol"
    type = "S"
  }

  tags = {
    Application = "${var.appName}"
    Env = "${var.env}"
  }
}




/*
output "tableNameEstructura" {
  value = "${aws_dynamodb_table.dynamodb-estructura-table.name}"
}

output "tableNamePresupuesto" {
  value = "${aws_dynamodb_table.dynamodb-presupuesto-table.name}"
}

output "tableNameTransaccion" {
  value = "${aws_dynamodb_table.dynamodb-transaccion-table.name}"
}
*/