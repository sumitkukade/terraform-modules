variable "region" {
  description = "GCP region"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "GCP zone"
  type        = string
  default     = "us-central1-a"
}

variable "instance_name" {
  description = "Name of the Jenkins instance"
  type        = string
  default     = "jenkins-server"
}

variable "instance_type" {
  description = "Instance type/machine type for Jenkins"
  type        = string
  default     = "e2-medium"
}

variable "allow_stopping_for_update" {
  description = "Allow stopping the instance for updates."
  type        = bool
  default     = true
}

variable "disk_size" {
  description = "Disk size in GB for Jenkins instance"
  type        = number
  default     = 10
}

variable "network" {
  description = "VPC network for Jenkins instance"
  type        = string
  default     = "default"
}

variable "preemptible" {
  description = "Whether the instance is preemptible (Spot instance)"
  type        = bool
  default     = true
}

variable "maintenance_policy" {
  description = "Maintenance policy for the instance"
  type        = string
  default     = "TERMINATE"
}

variable "automatic_restart" {
  description = "Whether the instance should automatically restart if terminated"
  type        = bool
  default     = false
}