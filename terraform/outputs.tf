output "state_bucket" {
  value = aws_s3_bucket.terraform-state-bucket.id
}

output "logging_bucket" {
  description = "The logging_bucket name"
  value       = aws_s3_bucket.state-logging-bucket.id
}

output "state_bucket_prefixes" {  
  description = "The state bucket prefixes for projects"
  value = aws_s3_object.proj_prefixes.*.key
}

# output "proj1_prefix" {
#   description = "The bucket prefix for proj1"
#   value       = aws_s3_object.proj1_name.key
# }

output "proj_dynamodb_tables" {
  description = "The name of the projects dynamo db tables"
  value = aws_dynamodb_table.proj_tables.*.id
}

# output "proj1_name_dynamodb_table" {
#   description = "The name of the proj1 dynamo db table"
#   value       = aws_dynamodb_table.proj1_name.id
# }