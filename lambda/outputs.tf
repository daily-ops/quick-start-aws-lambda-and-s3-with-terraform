
output "function_name" {
  description = "Name of the Lambda function."

  value = aws_lambda_function.upload_function.function_name
}

output "function_invoke_arn" {
  description = "ARN of the Lambda function."

  value = aws_lambda_function.upload_function.invoke_arn
}