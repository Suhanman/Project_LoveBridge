variable "project_id" {
  description = "GCP 프로젝트 ID"
  type        = string
}

variable "region" {
  description = "GCS 버킷 리전"
  default     = "us-central1"
}

variable "bucket_name" {
  description = "백업 저장용 GCS 버킷 이름"
  default     = "lovebridge-db-backups"
}
