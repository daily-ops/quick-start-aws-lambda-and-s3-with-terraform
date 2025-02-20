variable "aws_region" {
  description = "The AWS region to deploy resources."
  type        = string
}

variable "lambda_fileupload_invoke_arn" {
  description = "ARN of the file uploadlambda function to be invoked by the API Gateway"
  type = string
}

variable "lambda_fileupload_function_name" {
  description = "Name of the file upload lambda function"
  type = string
}