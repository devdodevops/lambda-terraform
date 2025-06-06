
# module "lambda_iam_role" {
#   count  = var.create_lambda_export ? 1 : 0
#   source = "./modules/iam"

#   role_name   = "${local.resource_prefix}-lambda-export-to-s3-role"
#   policy_name = "${local.resource_prefix}-lambda-export-to-s3-policy"

#   trusted_role_services   = ["lambda.amazonaws.com"]
#   create_instance_profile = false

#   policy = <<EOF
# {
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Effect": "Allow",
#             "Action": [
#                 "logs:DescribeExportTasks",
#                 "logs:DescribeLogGroups",
#                 "logs:CancelExportTask",
#                 "logs:CreateExportTask",
#                 "logs:DescribeLogStreams"
#             ],
#             "Resource": "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:*"
#         },
#         {
#             "Effect": "Allow",
#             "Action": [
#                 "s3:PutObject",
#                 "s3:GetBucketAcl"
#             ],
#             "Resource": [
#                 "${aws_s3_bucket.claimcenter_log_bucket.0.arn}/*",
#                 "${aws_s3_bucket.claimcenter_log_bucket.0.arn}"
#             ]
#         }
#     ]
# }
# EOF
# }

# resource "aws_lambda_function" "export_logs_to_s3" {
#   count            = var.create_lambda_export ? 1 : 0
#   filename         = "${path.module}/files/export-logs-to-s3.zip"
#   function_name    = "export_logs_to_s3"
#   description      = "Lambda function that's export cloudwatch logs into s3 for archiving"
#   role             = module.lambda_iam_role.0.iam_role_arn
#   handler          = "lambda_function.lambda_handler"
#   runtime          = "python3.12"
#   timeout          = 600
#   source_code_hash = filebase64sha256("${path.module}/files/export-logs-to-s3.zip")

#   environment {
#     variables = {
#       DESTINATION_BUCKET = "${aws_s3_bucket.claimcenter_log_bucket.0.id}"
#       GROUP_NAME         = "${var.claimcenetr_node01_serverid},${var.claimcenetr_node02_serverid},${var.claimcenetr_batch_serverid},${var.claimcenetr_contactmanager_serverid}"
#       PREFIX             = "CloudWatchLogs"
#     }
#   }
# }

# resource "aws_cloudwatch_event_rule" "daily_trigger" {
#   count               = var.create_lambda_export ? 1 : 0
#   name                = "daily_trigger"
#   description         = "Triggers daily at midnight"
#   schedule_expression = "cron(0 0 * * ? *)"
# }

# resource "aws_lambda_permission" "allow_cloudwatch" {
#   count         = var.create_lambda_export ? 1 : 0
#   statement_id  = "AllowExecutionFromCloudWatch"
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.export_logs_to_s3.0.function_name
#   principal     = "events.amazonaws.com"
#   source_arn    = aws_cloudwatch_event_rule.daily_trigger.0.arn
# }

# resource "aws_cloudwatch_event_target" "lambda_target" {
#   count     = var.create_lambda_export ? 1 : 0
#   rule      = aws_cloudwatch_event_rule.daily_trigger.0.name
#   target_id = "lambda"
#   arn       = aws_lambda_function.export_logs_to_s3.0.arn
# }

resource "aws_s3_bucket" "claimcenter_log_bucket" {
  count  = var.create_logger ? 1 : 0
  bucket = "${lower(local.resource_prefix)}-claimcenter-logs"

}

module "lambda_iam_role" {
  count  = var.create_lambda_function ? 1 : 0
  source = "./modules/iam"

  role_name   = "${local.resource_prefix}-lambda-export-to-s3-role"
  policy_name = "${local.resource_prefix}-lambda-export-to-s3-policy"

  trusted_role_services   = ["lambda.amazonaws.com"]
  create_instance_profile = false

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:DescribeExportTasks",
                "logs:DescribeLogGroups",
                "logs:CancelExportTask",
                "logs:CreateExportTask",
                "logs:DescribeLogStreams"
            ],
            "Resource": "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:GetBucketAcl"
            ],
            "Resource": [
                "${aws_s3_bucket.claimcenter_log_bucket.0.arn}/*",
                "${aws_s3_bucket.claimcenter_log_bucket.0.arn}"
            ]
        }
    ]
}
EOF
}

module "lambda" {
  source = "./modules/lambda"

  # Enable/disable Lambda creation
  count = var.create_lambda_function ? 1 : 0 # Set to false to disable

  # Lambda configuration
  function_name                = "export_logs_to_s3"
  function_handler             = "lambda_function.lambda_handler"
  function_runtime             = "python3.12"
  lambda_iam_role              = module.lambda_iam_role.0.iam_role_arn
  function_timeout_in_seconds  = 600
  function_source_dir          = "${path.module}/aws_lambda_functions/export_logs_to_s3"
  function_zip_output_dir      = "${path.module}/build"
  environment                  = "dev"
  destination_bucket    = aws_s3_bucket.claimcenter_log_bucket[count.index].id
  log_group_names       = [
    var.claimcenetr_node01_serverid,
    var.claimcenetr_node02_serverid,
    var.claimcenetr_batch_serverid,
    var.claimcenetr_contactmanager_serverid
  ]
  log_prefix            = "CloudWatchLogs"
}