output "api_url" {
  value = aws_api_gateway_deployment.api.invoke_url
}

output "sqs_url" {
  value = aws_sqs_queue.sqs.id
}
