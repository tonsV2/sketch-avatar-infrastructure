resource "aws_iam_role" "api_lambda" {
  name = "ApiController-lambda"
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

resource "aws_iam_role_policy_attachment" "AWSLambdaVPCAccessExecutionRole-api" {
  role = aws_iam_role.api_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_iam_role_policy_attachment" "s3" {
  role = aws_iam_role.api_lambda.name
  policy_arn = aws_iam_policy.s3.arn
}

resource "aws_iam_policy" "s3" {
  policy = data.aws_iam_policy_document.s3.json
}

data "aws_iam_policy_document" "s3" {
  statement {
    effect = "Allow"
    resources = [
      "arn:aws:s3:::${var.s3_legacy_bucket}/*"
    ]

    actions = [
      "s3:GetObject"
    ]
  }

  statement {
    effect = "Allow"
    resources = [
      "arn:aws:s3:::${var.s3_modern_bucket}/*"
    ]

    actions = [
      "s3:GetObject",
      "s3:PutObject",
    ]
  }
}
