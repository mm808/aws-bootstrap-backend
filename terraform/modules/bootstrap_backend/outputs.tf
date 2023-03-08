output "state_bucket" {
  description = "The state_bucket id"
  value = aws_s3_bucket.terraform-state-bucket.id
}

output "logging_bucket" {
  description = "The logging_bucket id"
  value       = aws_s3_bucket.state-logging-bucket.id
}

output "dynamodb_table" {
  description = "The id of the dynamo db table"
  value       = aws_dynamodb_table.terraform_state_lock.id
}