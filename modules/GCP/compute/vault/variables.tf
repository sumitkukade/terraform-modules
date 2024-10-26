# modules/vault/variables.tf

variable "project_id" {
  type = string
}

variable "region" {
  type = string
}

variable "zone" {
  type = string
}

variable "network" {
  type = string
}

variable "subnetwork" {
  type = string
}

variable "vault_version" {
  type = string
}

variable "service_account_email" {
  type        = string
  description = "Service account email to attach to the instance"
}

variable "gcs_bucket_name" {
  type = string
}
