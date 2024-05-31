resource "google_cloud_run_service" "server" {
  name     = "${var.name}-server"
  location = var.region

  traffic {
    percent         = 100
    latest_revision = true
  }

  template {
    spec {
      containers {
        image = var.image
        args  = ["server"]
        env {
          name = "VAULT_LOCAL_CONFIG"
          value_from {
            secret_key_ref {
              name = google_secret_manager_secret.config.secret_id
              key  = "latest"
            }
          }
        }
        dynamic "env" {
          for_each = local.service_env_vars
          content {
            name  = env.value.name
            value = env.value.value
          }
        }
        ports {
          name           = "http1"
          container_port = 8200
        }
        resources {
          limits = {
            cpu    = var.cpu
            memory = var.memory
          }
        }
      }
      service_account_name = google_service_account.vault.email
    }
    metadata {
      annotations = {
        "autoscaling.knative.dev/maxScale" = 1
      }
      labels = {
        "run.googleapis.com/startupProbeType" = "Default"
      }
    }
  }

  metadata {
    namespace = var.project_id
  }
}

# resource "google_cloud_run_service_iam_member" "noauth" {
#   project = google_cloud_run_service.server.project

#   location = google_cloud_run_service.server.location
#   service  = google_cloud_run_service.server.name

#   role   = "roles/run.invoker"
#   member = "allUsers"
# }
