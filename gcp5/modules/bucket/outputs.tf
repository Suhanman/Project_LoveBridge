output "bucket_name" {
  description = "생성된 GCS 백업 버킷 이름"
  value       = google_storage_bucket.db_backup_bucket.name
}
