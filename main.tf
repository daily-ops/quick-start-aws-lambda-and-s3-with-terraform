terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 5.0"
    }
  }
}

provider "aws" {
    region = var.aws_region
}

resource "random_string" "bucket_suffix" {
    length = 4
    special = false
}

module "s3" {
  source = "./s3"
  
  aws_region = var.aws_region
}

module "lambda" {
  source = "./lambda"

  aws_region = var.aws_region
  s3_bucket_id = module.s3.s3_bucket_id
  s3_data_bucket_id = module.s3.s3_data_bucket_id
  s3_data_bucket_arn = module.s3.s3_data_bucket_arn
}

module "api-gateway" {
  source = "./api-gateway"

  aws_region = var.aws_region
  lambda_fileupload_invoke_arn = module.lambda.function_invoke_arn
  lambda_fileupload_function_name = module.lambda.function_name
}