resource "aws_sqs_queue" "sqs_deadletter" {
  name = "legacy2modern-dead-letter"
}

resource "aws_sqs_queue" "sqs" {
  name = "legacy2modern"
/* TODO: If I enable this all messages goes to the dead letter queue
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.sqs_deadletter.arn
    maxReceiveCount = 4
  })
*/
}

resource "aws_lambda_event_source_mapping" "sqs" {
  event_source_arn = aws_sqs_queue.sqs.arn
  function_name = aws_lambda_function.legacy2modern.arn
  enabled = true
  batch_size = var.batch_size
}
