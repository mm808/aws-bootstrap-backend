variable "app_name" {
  description = "application name"
  type        = string
  default = "backend-bootstrap-monoprice-dev"
}

variable "env" {
  description = "environment we are deploying to"
  type        = string
  default = "dev"
}

variable "owner" {
  description = "the application owner"
  type        = string
  default     = "DevOps Team"
}

variable "region" {
  description = "aws region"
  type        = string
  default = "us-west-2"
}

variable "account_alias" {
  description = "aws account name"
  type = string
  default = "monoprice-dev"
}

variable "bucket_purpose" {
  description = "adds detail to bucket name"
  type = string
  default = "terraformstate"
}

variable "dynamodb_table_name" {
  description = "name for the dynamodb table"
  type = string
  default = "backend-bootstrap-terraformlock-dev"
}
