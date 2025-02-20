terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }


  }
}

provider "aws" {
  region = var.aws_region
}

data "archive_file" "upload_function" {
  type        = "zip"
  source_file = "${path.module}/functions/upload.py"
  output_path = "${path.module}/functions/upload.zip"
}

resource "aws_s3_object" "upload_function" {
  bucket = var.s3_bucket_id

  key    = "upload.zip"
  source = data.archive_file.upload_function.output_path

  etag = filemd5(data.archive_file.upload_function.output_path)
}

resource "aws_lambda_function" "upload_function" {
  function_name = "FileUploadFunction"

  s3_bucket = var.s3_bucket_id
  s3_key    = aws_s3_object.upload_function.key

  runtime = "python3.9"
  handler = "upload.lambda_handler"

    environment {
      variables = {
        RECEIPT_BUCKET = var.s3_data_bucket_id
      }
    }
  source_code_hash = data.archive_file.upload_function.output_base64sha256
  
  role = aws_iam_role.lambda_exec.arn
}


resource "aws_cloudwatch_log_group" "upload_function" {
  # checkov:skip=CKV_AWS_338: ADD REASON: No requirement to retain logs for learning purposes
  # checkov:skip=CKV_AWS_158: ADD REASON: Only for learning purposes, no encryption needed
  name = "/aws/lambda/${aws_lambda_function.upload_function.function_name}"

  retention_in_days = 30
}

resource "aws_iam_role" "lambda_exec" {
  name = "serverless_lambda"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_exec" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_s3" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

resource "aws_iam_policy" "lambda_policy" {
  name        = "lambda_policy"
  description = "Allow lambda to access S3 data bucket"
  policy      = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "s3:GetObject",
          "s3:PutObject",
        ],
        Resource = [
          "${var.s3_data_bucket_arn}/*",
        ],
      },
    ],
  })
}


