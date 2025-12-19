variable "create_lambda_function" {
  type        = bool
  default     = true
  description = "Enable/disable creation of all resources in this module"
}

variable "aws_region" {
  type = string
  default = "us-east-1"
}

variable "claimcenetr_node01_serverid" {
  description = "The Server ID to be used inside $TOMCAT_HOME/bin/setenv.sh file for claim center node 1"
  type        = string
  default     = "dawlccnod01"
}

variable "claimcenetr_node02_serverid" {
  description = "The Server ID to be used inside $TOMCAT_HOME/bin/setenv.sh file for claim center node 2"
  type        = string
  default     = "dawlccnod02"
}


variable "claimcenetr_batch_serverid" {
  description = "The Server ID to be used inside $TOMCAT_HOME/bin/setenv.sh file for batch server"
  type        = string
  default     = "dawlccbat01"
}

variable "claimcenetr_contactmanager_serverid" {
  description = "The Server ID to be used inside $TOMCAT_HOME/bin/setenv.sh file for contact manager"
  type        = string
  default     = "dawlcmnod01"
}

variable "environment" {
  description = "Either dev, qa, stg, prod"
  type        = string
}

variable "create_logger" {
  type = bool
  default = true
}

variable "schedule_expression" {
  description = "Forwarded schedule for the export lambda. Empty = default in child."
  type        = string
  default     = ""
}
