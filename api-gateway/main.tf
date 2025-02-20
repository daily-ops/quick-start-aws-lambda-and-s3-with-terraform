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

resource "aws_apigatewayv2_api" "fileupload" {
  name          = "lambda_fileupload_gw"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "fileupload" {
  api_id = aws_apigatewayv2_api.fileupload.id

  name        = "lambda_fileupload_stage"
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gw.arn

    format = jsonencode({
      requestId               = "$context.requestId"
      sourceIp                = "$context.identity.sourceIp"
      requestTime             = "$context.requestTime"
      protocol                = "$context.protocol"
      httpMethod              = "$context.httpMethod"
      resourcePath            = "$context.resourcePath"
      routeKey                = "$context.routeKey"
      status                  = "$context.status"
      responseLength          = "$context.responseLength"
      integrationErrorMessage = "$context.integrationErrorMessage"
      }
    )
  }
}

resource "aws_apigatewayv2_integration" "fileupload" {
  api_id = aws_apigatewayv2_api.fileupload.id

  integration_uri    = var.lambda_fileupload_invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "fileupload" {
  api_id = aws_apigatewayv2_api.fileupload.id

  route_key = "POST /upload"
  target    = "integrations/${aws_apigatewayv2_integration.fileupload.id}"
}

resource "aws_cloudwatch_log_group" "api_gw" {
  name = "/aws/api_gw/${aws_apigatewayv2_api.fileupload.name}"

  retention_in_days = 7
}

resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_fileupload_function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.fileupload.execution_arn}/*/*"
}
