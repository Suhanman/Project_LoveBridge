resource "aws_s3_bucket" "helm_repo" {
  bucket         = var.bucket_name
  force_destroy  = true
  tags = {
    Name = "helm-repo-private"
  }
}

resource "aws_s3_bucket_website_configuration" "helm_repo" {
  bucket = aws_s3_bucket.helm_repo.id

  index_document {
    suffix = "index.yaml"
  }

  error_document {
    key = "error.html"
  }
}

# 버킷 ACL 및 퍼블릭 액세스 차단 (중요)
resource "aws_s3_bucket_public_access_block" "helm_repo" {
  bucket = aws_s3_bucket.helm_repo.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
