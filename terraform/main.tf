# configure Terraform #
terraform {
  required_version = "1.3.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.38.0"
    }
  }
}

provider "aws" {
  region = var.region
  default_tags {
    tags = {
      App_Name    = var.app_name
      Environment = var.env
      Owner       = var.owner
      Managed_By  = "Terraform"
    }
  }
}

module "bootstrap_backend" {
  source = "./modules/bootstrap_backend"

  env = var.env
  region               = var.region
  account_alias        = var.account_alias
  bucket_purpose = var.bucket_purpose
  dynamodb_table_name  = var.dynamodb_table_name
}
