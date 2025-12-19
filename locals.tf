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

  # Required ARN variants
  bucket_arn_slash  = local.bucket_arn != null ? "${local.bucket_arn}/"  : null
  bucket_object_arn = local.bucket_arn != null ? "${local.bucket_arn}/*" : null

  # Final list to use in the IAM policy
  bucket_arn_variants = compact([
    local.bucket_arn_slash,
    local.bucket_object_arn
  ])
}
