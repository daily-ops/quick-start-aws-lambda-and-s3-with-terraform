output "s3_bucket_id" {
  value = aws_s3_bucket.lambda_bucket.id
}

output "s3_bucket_arn" {
  value = aws_s3_bucket.lambda_bucket.arn
}

output "s3_data_bucket_id" {
  value = aws_s3_bucket.data_bucket.id
}

output "s3_data_bucket_arn" {
  value = aws_s3_bucket.data_bucket.arn
}