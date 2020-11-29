resource "aws_cloudwatch_log_group" "worker" {
  name = "/aws/lambda/${aws_lambda_function.worker.function_name}"
  retention_in_days = 7
}

resource "aws_iam_role_policy_attachment" "worker" {
  role = aws_iam_role.worker.name
  policy_arn = aws_iam_policy.logging.arn
}
