resource "aws_lambda_function" "api" {
  function_name = "ApiController"

  timeout = 30

  s3_bucket = "mn-lambda"
  s3_key = "mn/v1.0.0/sketch-avatar-api-1.0.0-all.jar"

  handler = "io.micronaut.function.aws.proxy.MicronautLambdaHandler"
  runtime = "java11"

  memory_size = 1024

  role = aws_iam_role.api_lambda.arn

  vpc_config {
    security_group_ids = [aws_security_group.lambda.id]
    subnet_ids = [for subnet in aws_subnet.private: subnet.id]
  }

  environment {
    variables = {
      MICRONAUT_ENVIRONMENTS = "aws"
//      AWS_S3_REGION = var.region
      // TODO: This is a bad idea! This is the way... https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/UsingWithRDS.IAMDBAuth.Connecting.Java.html
      JDBC_DATABASE_URL = "jdbc:mariadb://${aws_db_instance.rds.address}:${aws_db_instance.rds.port}/${aws_db_instance.rds.name}"
      DATABASE_USERNAME = aws_db_instance.rds.username
      DATABASE_PASSWORD = aws_db_instance.rds.password
    }
  }
}
