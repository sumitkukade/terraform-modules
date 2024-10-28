output "cluster_name" {
  value = google_container_cluster.primary.name
}

output "cluster_endpoint" {
  value = google_container_cluster.primary.endpoint
}

output "cluster_ca_certificate" {
  value = google_container_cluster.primary.master_auth.0.cluster_ca_certificate
}

output "kubernetes_version" {
  value = google_container_cluster.primary.min_master_version
}

output "node_pool_name" {
  value = google_container_node_pool.primary_nodes.name
}
