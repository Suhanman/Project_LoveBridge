resource "google_compute_network" "vpc" {
  name                    = var.vpc_name
  auto_create_subnetworks = false
}


resource "google_compute_subnetwork" "subnet" {
  name          = var.subnet_name
  ip_cidr_range = var.subnet_cidr
  region        = var.region
  network       = google_compute_network.vpc.id
}

resource "google_compute_route" "allow_internet" {
  name             = "dr-vpc-allow-internet"
  network          = google_compute_network.vpc.name
  dest_range       = "0.0.0.0/0"
  next_hop_gateway = "default-internet-gateway"
  priority         = 1000
}

resource "google_compute_router" "router" {
  name    = "${var.vpc_name}-router"
  network = google_compute_network.vpc.id
  region  = var.region
}

resource "google_compute_router_nat" "nat" {
  name                               = "${var.vpc_name}-nat"
  router                             = google_compute_router.router.name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}




# Private Subnet A (DB용)
resource "google_compute_subnetwork" "private_subnet_db" {
  name                     = "${var.vpc_name}-private-db"
  ip_cidr_range            = var.subnet_cidr_db
  region                   = var.region
  network                  = google_compute_network.vpc.id
  private_ip_google_access = true
}

# Private Subnet B (Kubernetes용)
resource "google_compute_subnetwork" "private_subnet_kuber" {
  name                     = "${var.vpc_name}-private-b"
  ip_cidr_range            = var.subnet_cidr_kuber
  region                   = var.region
  network                  = google_compute_network.vpc.id
  private_ip_google_access = true
}

# SSH 허용 방화벽
resource "google_compute_firewall" "allow-ssh" {
  name    = "allow-ssh"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["allow-ssh"]
}

# Cloud SQL 등 프라이빗 연결을 위한 사설 IP 주소 범위 정의
resource "google_compute_global_address" "private_ip_range" {
  name           = "sql-private-range"
  purpose        = "VPC_PEERING"
  address_type   = "INTERNAL"
  prefix_length  = 16
  network        = google_compute_network.vpc.id
  depends_on     = [google_compute_network.vpc]  # VPC 생성 후 실행
}

# VPC Peering 연결 설정 (Cloud SQL, GKE에 필수)
resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = google_compute_network.vpc.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_range.name]
  depends_on              = [
    google_compute_global_address.private_ip_range,
    google_compute_subnetwork.private_subnet_db,
    google_compute_subnetwork.private_subnet_kuber
  ]
}

resource "google_compute_firewall" "allow_http" {
  name    = "allow-http"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["80", "8080"]
  }

  direction     = "INGRESS"
  source_ranges = ["0.0.0.0/0"]
  #target_tags   = ["allow-http"]
}
