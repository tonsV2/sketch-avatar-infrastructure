resource "aws_cloudwatch_log_group" "api" {
  name = "/aws/lambda/${aws_lambda_function.api.function_name}"
  retention_in_days = 7
}

resource "aws_iam_role_policy_attachment" "api" {
  role = aws_iam_role.api_lambda.name
  policy_arn = aws_iam_policy.api_logging.arn
}

resource "aws_iam_policy" "api_logging" {
  name = "ApiControllerLogging"
  path = "/"
  description = "IAM policy for logging from ApiController lambda"

  policy = data.aws_iam_policy_document.api_logging.json
}

data "aws_iam_policy_document" "api_logging" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogStream",
      "logs:CreateLogGroup",
      "logs:PutLogEvents"
    ]

    resources = ["arn:aws:logs:*:*:*"]
  }
}
