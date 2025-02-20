output "base_url" {
  description = "API Gateway base URL."
  value       = module.api-gateway.fileupload_invoke_url
}

output "function_name" {
  description = "Name of the Lambda function."
  value =  module.lambda.function_name
}

output "s3_bucket_id" {
  description = "ID of the S3 bucket storing the files."
  value = module.s3.s3_bucket_id
}