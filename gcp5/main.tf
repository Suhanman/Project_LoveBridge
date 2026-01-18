terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.14.0"
    }
  }
}

provider "google" {
  credentials = file("terraform-gcp-key.json")
  project     = var.project
  region      = var.region
}

provider "kubectl" {
  config_path    = "~/.kube/config"
  config_context = "gke_direct-tribute-463400-f2_us-central1_lovebridge-dr-cluster"
}

module "network" {
  source      = "./modules/network"
  project     = var.project
  region      = var.region
  vpc_name    = "dr-vpc"
  subnet_name = "dr-subnet"

  subnet_cidr       = "10.0.0.0/24"
  subnet_cidr_db    = "10.0.2.0/24"
  subnet_cidr_kuber = "10.0.3.0/24"
}

module "compute" {
  source         = "./modules/compute"
  vm_name        = var.vm_name
  machine_type   = var.machine_type
  zone           = var.zone
  image          = var.image
  vpc_id         = module.network.vpc_id
  subnet_name    = module.network.subnet_name

  startup_script = <<-EOT
    #!/bin/bash
    sudo apt update
    sudo apt install -y default-jdk
    echo "Spring Boot Ready"
  EOT

  docker_username = var.docker_username
  docker_password = var.docker_password
  docker_image    = var.docker_image
}

module "db" {
  source = "./modules/db"

  db_instance_name  = "lovebridge-instance"
  db_name           = "lovebridge_main"
  db_user           = "admin"
  db_password       = var.db_password
  region            = "us-central1"
  tier              = "db-g1-small"
  vpc_network_id    = module.network.vpc_id
  bucket_name       = var.bucket_name
  project      = var.project
  depends_on=[module.network]
}

module "bucket_backup" {
  source      = "./modules/bucket"
  project_id  = var.project
  region      = var.region
  bucket_name       = var.bucket_name
}

module "gke" {
  source       = "./modules/gke"
  region       = var.region
  vpc_id       = module.network.vpc_id
  project  = var.project
  subnet_name  = module.network.subnet_name
  node_count   = var.node_count
  machine_type = var.machine_type
}

output "client_key" {
  value     = module.gke.client_key
  sensitive = true
}

output "client_certificate" {
  value     = module.gke.client_certificate
  sensitive = true
}

output "ca_certificate" {
  value = module.gke.ca_certificate
}

module "static_ip" {
  source     = "./modules/static-ip"
  region     = var.region
  project_id = var.project
}

module "monitor" {
  source     = "./modules/monitor"
  project = var.project
}
resource "null_resource" "get_gke_credentials" {
  provisioner "local-exec" {
    command = "gcloud container clusters get-credentials ${module.gke.cluster_name} --region ${module.gke.region} --project ${var.project}"
  }

  depends_on = [module.gke]
}

