resource "google_project_iam_member" "monitoring_viewer" {
  project = var.project
  role    = "roles/monitoring.viewer"
  member  = "serviceAccount:${google_service_account.gcp_monitoring_sa.email}"
}

resource "google_project_iam_member" "monitoring_editor" {
  project = var.project
  role    = "roles/monitoring.editor"
  member  = "serviceAccount:${google_service_account.gcp_monitoring_sa.email}"
}
