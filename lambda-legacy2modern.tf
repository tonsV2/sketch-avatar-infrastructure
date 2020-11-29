resource "aws_lambda_function" "legacy2modern" {
  function_name = "LegacyToModernRequestHandler"

  timeout = var.lambda_worker_timeout

  s3_bucket = var.lambda_worker_s3_bucket
  s3_key = var.lambda_worker_s3_key

  handler = var.lambda_worker_handler
  runtime = var.lambda_worker_runtime

  memory_size = var.lambda_worker_memory_size
  reserved_concurrent_executions = var.lambda_worker_reserved_concurrent_executions

  role = aws_iam_role.legacy2modern.arn

  vpc_config {
    security_group_ids = [aws_security_group.lambda.id]
    subnet_ids = [for subnet in aws_subnet.private: subnet.id]
  }

  environment {
    variables = {
      MICRONAUT_ENVIRONMENTS = "aws"
      // TODO: This is a bad idea! This is the way... https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/UsingWithRDS.IAMDBAuth.Connecting.Java.html
      JDBC_DATABASE_URL = "jdbc:mariadb://${aws_db_instance.rds.address}:${aws_db_instance.rds.port}/${aws_db_instance.rds.name}"
      DATABASE_USERNAME = aws_db_instance.rds.username
      DATABASE_PASSWORD = aws_db_instance.rds.password
    }
  }
}
