resource "google_sql_database_instance" "instance" {
  name             = var.db_instance_name
  region           = var.region
  database_version = "MYSQL_8_0"
  deletion_protection = false

  settings {
    tier = var.tier

    ip_configuration {
      ipv4_enabled    = false
      private_network = var.vpc_network_id
    }

    backup_configuration {
      enabled             = true
      binary_log_enabled  = true
    }

    availability_type = "REGIONAL"
  }

 
}

resource "google_sql_database" "main" {
  name     = var.db_name
  instance = google_sql_database_instance.instance.name
  charset  = "utf8mb4"
  collation = "utf8mb4_general_ci"
  
}

resource "google_sql_user" "user" {
  name     = var.db_user
  instance = google_sql_database_instance.instance.name
  password = var.db_password
}



resource "null_resource" "grant_gcs_to_db_instance_sa" {
  depends_on = [google_sql_database_instance.instance]

  provisioner "local-exec" {
    interpreter = ["PowerShell", "-Command"]

    command = <<EOT
      $INSTANCE_NAME = "${google_sql_database_instance.instance.name}"
      $PROJECT_ID = "${var.project}"
      $BUCKET_NAME = "${var.bucket_name}"

      # 서비스 계정 이메일 조회
      $SA_EMAIL = (gcloud sql instances describe $INSTANCE_NAME --project=$PROJECT_ID --format="value(serviceAccountEmailAddress)")

      Write-Output "Granting roles/storage.objectAdmin to $SA_EMAIL on bucket $BUCKET_NAME"

      # IAM 권한 부여 (PowerShell 스타일로 인수 나열)
      gcloud storage buckets add-iam-policy-binding "gs://$BUCKET_NAME" `
        --member "serviceAccount:$SA_EMAIL" `
        --role "roles/storage.objectAdmin" `
        --project "$PROJECT_ID"
    EOT
  }
}
