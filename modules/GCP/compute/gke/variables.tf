variable "region" {
  description = "The GCP region"
  type        = string
  default     = "asia-south1"
}

variable "cluster_name" {
  description = "Name of the GKE cluster"
  type        = string
  default     = "gke-cluster"
}

variable "environment" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
  default     = "dev"
}

variable "enable_private_nodes" {
  description = "Enable private GKE nodes"
  type        = bool
  default     = true
}

variable "enable_private_endpoint" {
  description = "Enable private endpoint for GKE master"
  type        = bool
  default     = false
}

variable "master_ipv4_cidr_block" {
  description = "IPv4 CIDR block for GKE master"
  type        = string
  default     = "172.16.0.0/28"
}

variable "network" {
  description = "The VPC network to host the cluster in"
  type        = string
  default     = null
}

variable "subnetwork" {
  description = "The subnetwork to host the cluster in"
  type        = string
  default     = null
}

variable "machine_type" {
  description = "The type of machine for the node pool"
  type        = string
  default     = "e2-micro"
}

variable "disk_size_gb" {
  description = "Disk size for each node"
  type        = number
  default     = 100
}

variable "initial_node_count" {
  description = "Initial number of nodes in the node pool"
  type        = number
  default     = 1
}

variable "min_node_count" {
  description = "Minimum number of nodes for autoscaling"
  type        = number
  default     = 1
}

variable "max_node_count" {
  description = "Maximum number of nodes for autoscaling"
  type        = number
  default     = 10
}

variable "preemptible" {
  description = "Use preemptible VMs for node pool"
  type        = bool
  default     = false
}

variable "node_labels" {
  description = "Labels for the nodes in the node pool"
  type        = map(string)
  default     = {}
}

variable "node_tags" {
  description = "Network tags for the nodes"
  type        = list(string)
  default     = []
}

variable "node_locations" {
  description = "Locations (zones) for the node pool"
  type        = list(string)
  default     = []
}
