resource "aws_cloudwatch_log_group" "legacy2modern" {
  name = "/aws/lambda/${aws_lambda_function.legacy2modern.function_name}"
  retention_in_days = 7
}

resource "aws_iam_role_policy_attachment" "legacy2modern" {
  role = aws_iam_role.legacy2modern.name
  policy_arn = aws_iam_policy.logging.arn
}
