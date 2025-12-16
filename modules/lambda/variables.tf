variable "create_lambda_function" {
  type        = bool
  default     = true
  description = "Enable/disable creation of all resources in this module"
}

variable "environment" {
  type        = string
  description = "Environment name (e.g., dev, prod)"
}

variable "function_name" {
  type        = string
  description = "Name of the Lambda function"
}

variable "function_handler" {
  type        = string
  description = "Entrypoint for the Lambda function (e.g., index.handler)"
}

variable "function_runtime" {
  type        = string
  description = "Lambda runtime (e.g., nodejs14.x)"
}

variable "function_timeout_in_seconds" {
  type        = number
  description = "Timeout for the Lambda in seconds"
}

variable "function_source_dir" {
  type        = string
  description = "Path to Lambda source code directory"
}

variable "function_zip_output_dir" {
  type        = string
  description = "Output directory for the Lambda ZIP"
}

variable "destination_bucket" {
  type        = string
  default     = null
  description = "S3 bucket name for log storage (required for export functionality)"
}

variable "log_group_names" {
  type        = list(string)
  default     = null
  description = "List of CloudWatch log group names to export"
}

variable "log_prefix" {
  type        = string
  default     = "CloudWatchLogs"
  description = "S3 path prefix for exported logs"
}

variable "lambda_iam_role_arn" {
  type = string
}

variable "schedule_expression" {
  description = "Custom EventBridge cron expression for this function. If empty, use default daily at 00:00 UTC."
  type        = string
  default     = ""
}
