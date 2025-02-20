variable "aws_region" {
  description = "The AWS region to deploy resources."
  type        = string
}

variable "s3_bucket_id" {
  description = "The ID of the S3 bucket."
  type        = string
}

variable "s3_data_bucket_arn" {
  description = "The ARN of the S3 bucket for uploading data."
  type        = string
}

variable "s3_data_bucket_id" {
  description = "The ID of the S3 bucket for uploading data."
  type        = string
}
