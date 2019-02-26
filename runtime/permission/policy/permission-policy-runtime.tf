variable "prefix" {
  type = "string"
}

data "aws_iam_policy_document" "cloudwatchDataPolicy" {
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

resource "aws_iam_policy" "cloudwatchPolicy" {
  name = "${var.prefix}-cloudwatch-logs"
  path = "/"
  description = "Otorga privilegios para la creacion de logs CloudWatch"
  policy = "${data.aws_iam_policy_document.cloudwatchDataPolicy.json}"
}

output "outArnCloudwatchPolicy" {
  value = "${aws_iam_policy.cloudwatchPolicy.arn}"
}
