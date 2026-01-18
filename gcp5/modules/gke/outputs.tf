output "cluster_name" {
  value = google_container_cluster.lovebridge_cluster.name
}

output "endpoint" {
  value = google_container_cluster.lovebridge_cluster.endpoint
}

output "node_pool_name" {
  value = google_container_node_pool.primary_nodes.name
}

output "ca_certificate" {
  value = google_container_cluster.lovebridge_cluster.master_auth[0].cluster_ca_certificate
}

output "client_certificate" {
  value = google_container_cluster.lovebridge_cluster.master_auth[0].client_certificate
}

output "client_key" {
  value = google_container_cluster.lovebridge_cluster.master_auth[0].client_key
}

output "region" {
  value = var.region
}