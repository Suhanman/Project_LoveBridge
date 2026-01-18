resource "google_service_account_iam_member" "workload_identity_binding" {
  service_account_id = google_service_account.gcp_monitoring_sa.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${var.project}.svc.id.goog[${var.k8s_namespace}/gcp-monitoring-exporter-sa]"
}
