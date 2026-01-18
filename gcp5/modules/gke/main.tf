resource "google_container_cluster" "lovebridge_cluster" {
  name     = "lovebridge-dr-cluster"
  location = var.region

  remove_default_node_pool = true
  initial_node_count       = 1  # 필수지만 사용하지 않음

  deletion_protection = false

  network    = var.vpc_id
  subnetwork = var.subnet_name

  ip_allocation_policy {}
    workload_identity_config {
    workload_pool = "${var.project}.svc.id.goog"
  }
}

resource "google_container_node_pool" "primary_nodes" {
  name     = "primary-node-pool"
  location = var.region
  cluster  = google_container_cluster.lovebridge_cluster.name

  node_count = var.node_count

  node_config {
    machine_type = var.machine_type

    disk_type    = "pd-standard"  # SSD 대신 일반 HDD 사용
    disk_size_gb = 30             # 디스크 용량 축소 (기존보다 적게 설정)

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}
