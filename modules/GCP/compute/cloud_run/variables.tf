variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The region for the Cloud Run service"
  type        = string
  default     = "asia-south1"
}

variable "service_name" {
  description = "Name of the Cloud Run service"
  type        = string
  default     = "my-service"
}

variable "image_url" {
  description = "Container image URL for the service"
  type        = string
}

# Lowering memory and CPU to minimize cost
variable "memory" {
  description = "Memory limit for the container"
  type        = string
  default     = "256Mi"
}

variable "cpu" {
  description = "CPU limit for the container"
  type        = string
  default     = "0.25"
}

variable "env_var_value" {
  description = "Environment variable value for the container"
  type        = string
  default     = "dev"
}

variable "env_vars" {
  description = "Map of environment variables to pass to Cloud Run from Vault."
  type        = map(string)
  default     = {}
}
