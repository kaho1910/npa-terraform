output "id" {
  description = "Name (id) of the bucket"
  value       = aws_s3_bucket.s3_bucket.id
}

output "web_bucket" {
  description = "Bucket"
  value       = aws_s3_bucket.s3_bucket
}