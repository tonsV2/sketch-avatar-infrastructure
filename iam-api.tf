resource "aws_iam_role" "api_lambda" {
  name = "ApiController"
  assume_role_policy = data.aws_iam_policy_document.api.json
}

data "aws_iam_policy_document" "api" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      identifiers = ["lambda.amazonaws.com"]
      type = "Service"
    }
  }
}

resource "aws_iam_role_policy_attachment" "AWSLambdaVPCAccessExecutionRole-example" {
  role = aws_iam_role.api_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}
