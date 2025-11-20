# Conditional creation of build directory
resource "null_resource" "create_build_dir" {
  count = var.create_lambda_function ? 1 : 0

  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = "mkdir -p ${var.function_zip_output_dir}"
  }
}

# Conditional ZIP creation
data "archive_file" "function_zip" {
  count = var.create_lambda_function ? 1 : 0

  depends_on  = [null_resource.create_build_dir[0]]
  type        = "zip"
  source_dir  = var.function_source_dir
  output_path = "${var.function_zip_output_dir}/${var.function_name}.zip"
}

# Conditional Lambda function
resource "aws_lambda_function" "function" {
  count = var.create_lambda_function ? 1 : 0

  function_name = "${var.function_name}-${var.environment}"
  handler       = var.function_handler
  runtime       = var.function_runtime
  timeout       = var.function_timeout_in_seconds
  role          = var.lambda_iam_role_arn

  filename         = data.archive_file.function_zip[0].output_path
  source_code_hash = data.archive_file.function_zip[0].output_base64sha256

  # environment {
  #   variables = {
  #     ENVIRONMENT = var.environment
  #   }
  # }

  environment {
    variables = merge({
      ENVIRONMENT = var.environment
      PREFIX      = var.log_prefix
    }, var.destination_bucket != null ? {
      DESTINATION_BUCKET = var.destination_bucket
    } : {}, var.log_group_names != null ? {
      GROUP_NAME = join(",", var.log_group_names)
    } : {})
  }

}

# # Conditional IAM role
# resource "aws_iam_role" "function_role" {
#   count = var.create_lambda_function ? 1 : 0

#   name = "${var.function_name}-${var.environment}"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Principal = {
#           Service = "lambda.amazonaws.com"
#         }
#       }
#     ]
#   })
# }

# Conditional policy attachment
# resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
#   count = var.create_lambda_function ? 1 : 0

#   role       = var.lambda_iam_role_name
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
# }

resource "aws_cloudwatch_event_rule" "daily_trigger" {
  count               = var.create_lambda_function ? 1 : 0
  name                = "${var.function_name}-${var.environment}-daily-trigger"
  description         = "Triggers daily at midnight"
  schedule_expression = "cron(0 0 * * ? *)"
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  count         = var.create_lambda_function ? 1 : 0
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.function[0].function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.daily_trigger[0].arn
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  count     = var.create_lambda_function ? 1 : 0
  rule      = aws_cloudwatch_event_rule.daily_trigger[0].name
  target_id = "lambda"
  arn       = aws_lambda_function.function[0].arn
}
