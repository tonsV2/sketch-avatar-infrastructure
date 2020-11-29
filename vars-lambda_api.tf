variable "lambda_api_timeout" {
  default = 10
}

variable "lambda_api_s3_bucket" {
  default = "mn-lambda"
}

variable "lambda_api_s3_key" {
  default = "mn/v1.0.0/sketch-avatar-api-1.0.0-all.jar"
}

variable "lambda_api_handler" {
  default = "io.micronaut.function.aws.proxy.MicronautLambdaHandler"
}

variable "lambda_api_runtime" {
  default = "java11"
}

variable "lambda_api_memory_size" {
  default = 1024
}

variable "lambda_api_reserved_concurrent_executions" {
  default = 2
}
