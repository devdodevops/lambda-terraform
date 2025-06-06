output "lambda_arn" {
  description = "ARN of the Lambda function"
  value       = var.create_lambda_function ? aws_lambda_function.function[0].arn : null
}

output "cloudwatch_rule_arn" {
  description = "ARN of the CloudWatch Event Rule"
  value       = var.create_lambda_function ? aws_cloudwatch_event_rule.daily_trigger[0].arn : null
}