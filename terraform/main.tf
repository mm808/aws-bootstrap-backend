# ~~~ configure Terraform ~~~ #
terraform {
  required_version = "=1.3.0"
  backend "local" {
    path = "/backend/${var.env}/terraform.tfstate"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.38.0"
    }
  }
}

# config aws provider
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

# ~~~ state bucket ~~~ #
resource "aws_s3_bucket" "terraform-state-bucket" {
  bucket = "monoprice-tfstate-${var.env}"
}

resource "aws_s3_bucket_logging" "terraform-state-bucket" {
  bucket = aws_s3_bucket.terraform-state-bucket.id

  target_bucket = aws_s3_bucket.state-logging-bucket.id
  target_prefix = "logs/"
}

resource "aws_s3_bucket_versioning" "terraform-state-bucket" {
  bucket = aws_s3_bucket.terraform-state-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "terraform-state-bucket" {
  bucket = aws_s3_bucket.terraform-state-bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_ownership_controls" "terraform-state-bucket" {
  bucket = aws_s3_bucket.terraform-state-bucket.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform-state-bucket" {
  bucket = aws_s3_bucket.terraform-state-bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# ~~~ bucket prefixes ~~~ # 
# one for each Terraform project
# controlled through the project_names var

resource "aws_s3_object" "proj_prefixes" {
  bucket       = aws_s3_bucket.terraform-state-bucket.id
  count = length(var.project_names)
  key          = "${var.project_names[count.index]}/"
  content_type = "application/x-directory"
}

# ~~~ logging bucket ~~~#
# this receives the Server Access logs of the state file bucket

resource "aws_s3_bucket" "state-logging-bucket" {
  bucket = "monoprice-state-logging-${var.env}"
}

resource "aws_s3_object" "logs_prefix" {
  bucket       = aws_s3_bucket.state-logging-bucket.id
  key          = "logs/"
  content_type = "application/x-directory"
}

resource "aws_s3_bucket_acl" "state-logging-bucket" {
  bucket = aws_s3_bucket.state-logging-bucket.id
  acl    = "log-delivery-write"
}

resource "aws_s3_bucket_public_access_block" "state-logging-bucket" {
  bucket = aws_s3_bucket.state-logging-bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "state-logging-bucket" {
  bucket = aws_s3_bucket.state-logging-bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# ~~~ dynamodb tables ~~~ #
# one for each Terraform project
# controlled through the project_names var

resource "aws_dynamodb_table" "proj_tables" {
  count = length(var.project_names)
  name           = "${var.project_names[count.index]}-terraformlock-${var.env}"
  hash_key       = "LockID"
  read_capacity  = 2
  write_capacity = 2

  server_side_encryption {
    enabled = true
  }

  attribute {
    name = "LockID"
    type = "S"
  }
}
