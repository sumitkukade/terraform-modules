output "instance_connection_name" {
  description = "The connection name of the Cloud SQL instance."
  value       = google_sql_database_instance.postgres.connection_name
}

output "public_ip_address" {
  description = "The public IP address of the Cloud SQL instance."
  value       = google_sql_database_instance.postgres.public_ip_address
}

output "instance_name" {
  description = "The name of the Cloud SQL instance."
  value       = google_sql_database_instance.postgres.name
}
