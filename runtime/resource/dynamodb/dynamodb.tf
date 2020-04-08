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

resource "aws_dynamodb_table" "dynamodb-roles-exclusion-table2" {
  name = "${var.appPrefix}-roles-beneficios"
  billing_mode = "PAY_PER_REQUEST"
  
  hash_key = "rol"
  range_key = "beneficio"

  attribute {
    name = "rol"
    type = "S"
  }
  
  attribute {
    name = "beneficio"
    type = "S"
  }

  tags = {
    Application = "${var.appName}"
    Env = "${var.env}"
  }
}

output "beneficiosTableName" {
  value = "${aws_dynamodb_table.dynamodb-roles-exclusion-table2.name}"
}
