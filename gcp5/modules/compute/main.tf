resource "google_compute_instance" "vm_instance" {
  name         = var.vm_name
  machine_type = var.machine_type
  zone         = var.zone
  allow_stopping_for_update = true  # ← 이 줄 추가하면 해결

  boot_disk {
    initialize_params {
      image = var.image  # 예: "debian-cloud/debian-11"
      
    }
  }

  network_interface {
    network    = var.vpc_id
    subnetwork = var.subnet_name
    access_config {}  # 퍼블릭 IP 부여
  }

  tags = ["allow-ssh", "allow-http"]  # 방화벽 규칙 적용용 태그

 


  metadata = {
    startup-script = <<-EOT
      #!/bin/bash
      apt-get update
      apt-get install -y docker.io

      echo "${var.docker_password}" | docker login -u "${var.docker_username}" --password-stdin
      docker pull ${var.docker_image}
      docker run -d -p 80:8080 ${var.docker_image}
    EOT
  }
}

