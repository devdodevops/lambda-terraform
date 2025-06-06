output "lambda_arn" {
  description = "ARN of the Lambda function"
  value       = var.create_lambda_function ? aws_lambda_function.function[0].arn : null
}

output "role_arn" {
  description = "ARN of the IAM role for the Lambda"
  value       = var.create_lambda_function ? module.lambda_iam_role.0.iam_role_arn : null
}

output "cloudwatch_rule_arn" {
  description = "ARN of the CloudWatch Event Rule"
  value       = var.create_lambda_function ? aws_cloudwatch_event_rule.daily_trigger[0].arn : null
}