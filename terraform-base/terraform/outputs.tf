output "remote_state_bucket_name" {
  description = "The name of the s3 bucket created to store state"
  value       = aws_s3_bucket.remote_state.bucket
}

output "remote_state_logging_name" {
  description = "The name of the s3 bucket created to store state"
  value       = aws_s3_bucket.remote_state_logging.bucket
}
