resource "aws_iam_role" "worker" {
  name = "Worker-lambda"
  assume_role_policy = data.aws_iam_policy_document.api.json
}

resource "aws_iam_role_policy_attachment" "AWSLambdaVPCAccessExecutionRole-worker" {
  role = aws_iam_role.worker.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_iam_role_policy_attachment" "s3-worker" {
  role = aws_iam_role.worker.name
  policy_arn = aws_iam_policy.s3.arn
}

resource "aws_iam_role_policy_attachment" "sqs" {
  role = aws_iam_role.worker.name
  policy_arn = aws_iam_policy.sqs.arn
}

resource "aws_iam_policy" "sqs" {
  policy = data.aws_iam_policy_document.sqs.json
}

data "aws_iam_policy_document" "sqs" {
  statement {
    effect = "Allow"
    resources = [aws_sqs_queue.sqs.arn]

    actions = [
      "sqs:ReceiveMessage",
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes",
    ]
  }
}
