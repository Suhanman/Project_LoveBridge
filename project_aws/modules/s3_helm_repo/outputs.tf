output "bucket_name" {
  value = aws_s3_bucket.helm_repo.bucket
}

output "website_endpoint" {
  value = aws_s3_bucket_website_configuration.helm_repo.website_endpoint
}