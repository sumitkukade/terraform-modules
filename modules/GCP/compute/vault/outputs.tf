output "vault_server_ip" {
  description = "The public IP address of the Vault server instance."
  value       = google_compute_instance.vault_server.network_interface[0].access_config[0].nat_ip
}

output "vault_server_name" {
  description = "The name of the Vault server instance."
  value       = google_compute_instance.vault_server.name
}

output "vault_server_self_link" {
  description = "The self-link of the Vault server instance."
  value       = google_compute_instance.vault_server.self_link
}

output "vault_firewall_name" {
  description = "The name of the firewall rule applied to the Vault server."
  value       = google_compute_firewall.vault_firewall.name
}