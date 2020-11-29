variable "lambda_worker_timeout" {
  default = 10
}

variable "lambda_worker_s3_bucket" {
  default = "mn-lambda"
}

variable "lambda_worker_s3_key" {
  default = "mn/v1.0.0/sketch-avatar-api-1.0.0-all.jar"
}

variable "lambda_worker_handler" {
  default = "sketch.avatar.api.handler.LegacyToModernRequestHandler"
}

variable "lambda_worker_runtime" {
  default = "java11"
}

variable "lambda_worker_memory_size" {
  default = 1024
}

variable "lambda_worker_reserved_concurrent_executions" {
  default = 2
}

variable "batch_size" {
  default = 5
}
