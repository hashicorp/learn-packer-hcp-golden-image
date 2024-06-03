# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

output "gateway" {
  description = "URL of the webhook endpoint"

  value       = aws_apigatewayv2_api.version_events_webhook.api_endpoint
}

output "base_url" {
  description = "Base URL for API Gateway stage."

  value = aws_apigatewayv2_stage.version_events_webhook.invoke_url
}

output "function_name" {
  description = "Name of the Lambda function."

  value = aws_lambda_function.version_events_webhook.function_name
}
