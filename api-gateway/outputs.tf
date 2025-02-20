output "fileupload_invoke_url" {
  description = "API Gateway base URL."
  value       = aws_apigatewayv2_stage.fileupload.invoke_url
}
