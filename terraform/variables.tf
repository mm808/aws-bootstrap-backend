variable "env" {
  description = "environment we are deploying to"
  type        = string
}

variable "app_name" {
  description = "application name"
  type        = string
}

variable "owner" {
  description = "the application owner"
  type        = string
  default     = "DevOps Team"
}

variable "region" {
  description = "aws region"
  type        = string
}

variable "project_names" {
  description = "list of project names used in state bucket prefixes and db tables"
  type        = list(string)
}

# variable "proj1_name" {
#   description = "name for a terraform project, used for bucket prefix and dynamodb table name"
#   type        = string
# }

