variable "role_name" {
  description = "The name of the role"
  type        = string
}

variable "role_path" {
  description = "The path of the role in IAM"
  type        = string
  default     = "/"
}

variable "role_description" {
  description = "The description of the role"
  type        = string
  default     = "IAM Role"
}
variable "policy_name" {
  description = "The name of the policy"
  type        = string
}

variable "policy_path" {
  description = "The path of the policy in IAM"
  type        = string
  default     = "/"
}

variable "policy_description" {
  description = "The description of the policy"
  type        = string
  default     = "IAM Policy"
}

variable "policy" {
  description = "The path of the policy in IAM (tpl file)"
  type        = string
  default     = ""
}

variable "trusted_role_actions" {
  description = "Actions of STS"
  type        = list(string)
  default     = ["sts:AssumeRole"]
}


variable "trusted_role_arns" {
  description = "ARNs of AWS entities who can assume these roles"
  type        = list(string)
  default     = []
}

variable "trusted_role_services" {
  description = "AWS Services that can assume these roles"
  type        = list(string)
  default     = []
}

variable "create_instance_profile" {
  description = "Whether to create an instance profile"
  type        = bool
  default     = false
}

variable "managed_policy_arns" {
  description = "Set of exclusive IAM managed policy ARNs to attach to the IAM role"
  type        = list(string)
  default     = []
}
