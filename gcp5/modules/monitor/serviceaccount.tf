resource "google_service_account" "gcp_monitoring_sa" {
  account_id   = "gcp-monitoring-exporter"
  display_name = "Prometheus Stackdriver Exporter"
}
