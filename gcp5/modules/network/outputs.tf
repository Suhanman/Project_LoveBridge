output "vpc_id" {
  description = "생성된 VPC self_link"
  value       = google_compute_network.vpc.self_link
}

output "private_vpc_connection" {
  value = google_service_networking_connection.private_vpc_connection
}


output "subnet_name" {
  description = "서브넷 이름"
  value       = google_compute_subnetwork.subnet.name
}


