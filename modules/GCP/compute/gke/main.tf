resource "google_container_cluster" "primary" {
  name               = "${var.cluster_name}-${var.environment}"
  location           = var.region
  initial_node_count = 1
  remove_default_node_pool = true

  # Enable private nodes for security
  private_cluster_config {
    enable_private_nodes    = var.enable_private_nodes
    enable_private_endpoint = var.enable_private_endpoint
    master_ipv4_cidr_block  = var.master_ipv4_cidr_block
  }

  # Security - Enable Shielded Nodes
  enable_shielded_nodes = true

  # Logging and Monitoring
  logging_service    = "logging.googleapis.com/kubernetes"
  monitoring_service = "monitoring.googleapis.com/kubernetes"

  # Add optional subnetwork (if defined)
  network            = var.network
  subnetwork         = var.subnetwork

  # IP Allocation (VPC-native Cluster)
  ip_allocation_policy {
    use_ip_aliases = true
  }
}

resource "google_container_node_pool" "primary_nodes" {
  name       = "${var.cluster_name}-node-pool"
  location   = var.region
  cluster    = google_container_cluster.primary.name
  node_count = var.initial_node_count

  autoscaling {
    min_node_count = var.min_node_count
    max_node_count = var.max_node_count
  }

  management {
    auto_upgrade = true
    auto_repair  = true
  }

  node_config {
    machine_type = var.machine_type
    preemptible  = var.preemptible
    disk_size_gb = var.disk_size_gb

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    metadata = {
      disable-legacy-endpoints = "true"
    }

    labels = var.node_labels
    tags   = var.node_tags
  }

  dynamic "node_locations" {
    for_each = var.node_locations
    content {
      node_locations = node_locations.value
    }
  }
}
