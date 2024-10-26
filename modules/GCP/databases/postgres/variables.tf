variable "instance_name" {
  description = "The name of the Cloud SQL instance."
  type        = string
}

variable "database_version" {
  description = "The PostgreSQL version for the Cloud SQL instance."
  type        = string
  default     = "POSTGRES_17"
}

variable "region" {
  description = "The GCP region for the Cloud SQL instance."
  type        = string
}

variable "tier" {
  description = "The machine tier (e.g., db-f1-micro)."
  type        = string
}

variable "authorized_networks" {
  description = "List of networks allowed to connect to the instance."
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "db_username" {
  description = "The username for the PostgreSQL database."
  type        = string
}

variable "db_password" {
  description = "The password for the PostgreSQL user."
  type        = string
  sensitive   = true
}

variable "db_name" {
  description = "The name of the PostgreSQL database."
  type        = string
}

variable "deletion_protection" {
  description = "Enable deletion protection on the instance."
  type        = bool
  default     = false
}

variable "ipv4_enabled" {
  description = "Whether the instance should be assigned a public IPv4 address."
  type        = bool
  default     = true
}