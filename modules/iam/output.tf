output "iam_role_arn" {
  description = "ARN of IAM role"
  value       = aws_iam_role.this.arn
}

output "iam_instance_profile_arn" {
  description = "ARN of IAM instance profile"
  value       = element(concat(aws_iam_instance_profile.this.*.arn, [""]), 0)
}

output "iam_instance_profile_name" {
  description = "Name of IAM instance profile"
  value       = element(concat(aws_iam_instance_profile.this.*.name, [""]), 0)
}

output "iam_instance_profile_id" {
  description = "IAM Instance profile's ID."
  value       = element(concat(aws_iam_instance_profile.this.*.id, [""]), 0)
}
