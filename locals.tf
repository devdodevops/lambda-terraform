locals {
    resource_prefix = var.environment

  # Map of environment → base bucket ARN (without slash)
  env_bucket_map = {
    dev  = "arn:aws:s3:::dev01"
    qa   = "arn:aws:s3:::qa01"
    stg  = "arn:aws:s3:::stg01"
    prod = "arn:aws:s3:::prod01"
  }

  # Resolve bucket ARN
  bucket_arn = lookup(local.env_bucket_map, var.environment, null)
}
