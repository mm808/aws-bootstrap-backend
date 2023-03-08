locals {
  state_bucket   = "${var.account_alias}-${var.bucket_purpose}-${var.region}"
  logging_bucket = "${var.account_alias}-${var.bucket_purpose}-logs-${var.region}"
}

# terraform state bucket #
resource "aws_s3_bucket" "terraform-state-bucket" {
  bucket = local.state_bucket
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

resource "aws_s3_bucket_logging" "terraform-state-bucket" {
  bucket = aws_s3_bucket.terraform-state-bucket.id
  target_bucket = aws_s3_bucket.state-logging-bucket.id
  target_prefix = "logs/"
}

# logging bucket #
resource "aws_s3_bucket" "state-logging-bucket" {
  bucket = local.logging_bucket
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

# dynamodb table #
resource "aws_dynamodb_table" "terraform_state_lock" {
  name           = var.dynamodb_table_name
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
