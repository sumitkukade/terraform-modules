resource "google_sql_database_instance" "postgres" {
  name             = var.instance_name
  database_version = var.database_version
  region           = var.region

  settings {
    tier = var.tier

    ip_configuration {
      ipv4_enabled = var.ipv4_enabled

      dynamic "authorized_networks" {
        for_each = var.authorized_networks
        content {
          name  = authorized_networks.value.name
          value = authorized_networks.value.value
        }
      }
    }
  }

  deletion_protection = var.deletion_protection
}

resource "google_sql_user" "postgres_user" {
  name     = var.db_username
  password = var.db_password
  instance = google_sql_database_instance.postgres.name
}

resource "google_sql_database" "postgres_db" {
  name     = var.db_name
  instance = google_sql_database_instance.postgres.name
}
