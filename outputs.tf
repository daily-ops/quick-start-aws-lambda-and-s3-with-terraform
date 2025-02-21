output "base_url" {
  description = "API Gateway base URL."
  value       = module.api-gateway.fileupload_invoke_url
}

output "function_name" {
  description = "Name of the Lambda function."
  value =  module.lambda.function_name
}

output "function_arn" {
  description = "ARN of the Lambda function."
  value = module.lambda.function_invoke_arn
}

output "s3_bucket_id" {
  description = "ID of the S3 bucket storing the Lambda function files."
  value = module.s3.s3_bucket_id
}

output "s3_bucket_arn" {
  description = "ARN of the S3 bucket storing the Lambda function files."
  value = module.s3.s3_bucket_arn
}

output "s3_data_bucket_id" {
  description = "ID of the S3 bucket storing the files."
  value = module.s3.s3_data_bucket_id
}

output "s3_data_bucket_arn" {
  description = "ARN of the S3 bucket storing the files."
  value = module.s3.s3_data_bucket_arn
}