variable "prefix" {
  type = "string"
}

/*
data "aws_iam_policy_document" "data_policy_dyndb" {
  statement {
    sid      = "dynamodbAccess"
    actions  = [
      "dynamodb:CreateTable",
      "dynamodb:PutItem",
      "dynamodb:DescribeTable",
      "dynamodb:DeleteItem",
      "dynamodb:GetItem",
      "dynamodb:Scan",
      "dynamodb:Query",
      "dynamodb:UpdateItem",
      "dynamodb:DeleteTable"
    ]
    resources = [
      "${var.arnGiradoresTable}",
	    "${var.arnIrasTable}",
    ]
  }
}

data "aws_iam_policy_document" "data_policy_ses" {
  statement {
    sid       = "sesSendEmail"
    actions   = [
      "ses:Send*"
      ]
    resources = ["*"]
      condition = {
        test     = "StringLike"
        variable = "ses:FromAddress"
        values   = ["boton-pago@tgr.cl"]
        test     = "ForAnyValue:StringEquals"
        variable = "ses:Recipients"
        values   = [
                    "abilbao@valio.cl",
                    "jose@valio.cl",
                    "angel.nunez@gmail.com",
                    "dsaldias@tgr.cl",
                    "gpvegam@gmail.com",
                    "dan.saldias@gmail.com"
              ]
        }
    } 
  statement {
    sid       = "sesList"
    actions   = [
                "ses:Get*",
                "ses:List*",
                "ses:Describe*",
                "ses:Verify*"
      ]
    resources = ["*"]
    }
}
*/

data "aws_iam_policy_document" "data_policy_cloudwatch" {
  statement {
    sid = "putLogsEventsCloudWatch"
    actions = [
      "logs:PutLogEvents"
    ]
    resources = [
      "arn:aws:logs:*:*:log-group:/aws/lambda/*:*:*"]
  }
  statement {
    sid = "CreateLogsCloudWatch"
    actions = [
      "logs:CreateLogStream"
    ]
    resources = [
      "arn:aws:logs:*:*:log-group:/aws/lambda/*:*"]
  }
}

/*
resource "aws_iam_policy" "policy_dyndb" {
  name        = "${var.prefix}-dynamobd"
  path        = "/"
  description = "Otorga privilegios de lectura y escritura sobre las tablas de la aplicacion"
  policy      = "${data.aws_iam_policy_document.data_policy_dyndb.json}"
}

resource "aws_iam_policy" "policy_ses" {
  name        = "${var.prefix}-ses"
  path        = "/"
  description = "Otorga privilegios para el envio de correos mediante el servicio SES"
  policy      = "${data.aws_iam_policy_document.data_policy_ses.json}"
}
*/

resource "aws_iam_policy" "policy_cloudwatch" {
  name = "${var.prefix}-cloudwatch-logs"
  path = "/"
  description = "Otorga privilegios para la creacion de logs CloudWatch"
  policy = "${data.aws_iam_policy_document.data_policy_cloudwatch.json}"
}

/*
output "out_arn_policy_dyndb" {
  value = "${aws_iam_policy.policy_dyndb.arn}"
}
output "out_arn_policy_ses" {
  value = "${aws_iam_policy.policy_ses.arn}"
}
*/

output "out_arn_policy_cloudwatch" {
  value = "${aws_iam_policy.policy_cloudwatch.arn}"
}
