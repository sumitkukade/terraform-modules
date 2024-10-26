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
