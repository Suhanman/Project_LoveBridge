resource "google_compute_address" "gke_ingress_ip" {
  name         = "gke-ingress-ip"
  address_type = "EXTERNAL"
  network_tier = "PREMIUM"
  region       = var.region
  project      = var.project_id
}
