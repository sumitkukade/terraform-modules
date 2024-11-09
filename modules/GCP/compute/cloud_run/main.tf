# Create the service account
resource "google_service_account" "cloud_run_service_account" {
  account_id   = "${var.service_name}-sa"
  display_name = "${var.service_name} Service Account"
}

# Grant the service account the necessary roles
resource "google_project_iam_member" "cloud_run_invoker" {
  project = var.project_id
  role    = "roles/run.invoker"
  member  = "serviceAccount:${google_service_account.cloud_run_service_account.email}"
}

# Grant additional IAM roles for permissions
resource "google_project_iam_member" "service_account_user" {
  project = var.project_id
  role    = "roles/iam.serviceAccountUser"
  member  = "serviceAccount:${google_service_account.cloud_run_service_account.email}"
}

resource "google_project_iam_member" "editor_role" {
  project = var.project_id
  role    = "roles/editor"
  member  = "serviceAccount:${google_service_account.cloud_run_service_account.email}"
}

resource "google_cloud_run_service" "cloud_run_service" {
  name     = var.service_name
  location = var.region

  template {
    metadata {
      annotations = {
        "run.googleapis.com/timeout" = "300s" # Set timeout to 5 minutes
      }
    }
    spec {
      containers {
        image = var.image_url

        resources {
          limits = {
            memory = var.memory
            cpu    = var.cpu
          }
        }

        dynamic "env" {
          for_each = tomap({ for k, v in var.env_vars : k => { name = k, value = v } })
          content {
            name  = env.value.name
            value = env.value.value
          }
        }
      }

      service_account_name = google_service_account.cloud_run_service_account.email
    }
  }

  autogenerate_revision_name = var.autogenerate_revision_name
}

# IAM Binding to allow unauthenticated access if needed
resource "google_cloud_run_service_iam_member" "allow_unauthenticated" {
  project    = var.project_id
  location   = google_cloud_run_service.cloud_run_service.location
  service    = google_cloud_run_service.cloud_run_service.name
  role       = "roles/run.invoker"
  member     = "allUsers" # Allows public access
  depends_on = [google_cloud_run_service.cloud_run_service]
}

output "cloud_run_url" {
  value = google_cloud_run_service.cloud_run_service.status[0].url
}