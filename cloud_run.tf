resource "google_cloud_run_service" "vault_server" {
  name     = "${var.name}-server"
  location = var.region

  traffic {
    percent         = 100
    latest_revision = true
  }

  template {
    spec {
      containers {
        image = var.vault_image
        args  = ["server"]
        env {
          name = "VAULT_LOCAL_CONFIG"
          value_from {
            secret_key_ref {
              name = google_secret_manager_secret.vault_config.secret_id
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
            cpu    = var.vault_cpu
            memory = var.vault_memory
          }
        }
      }
      service_account_name = google_service_account.vault.email
    }
    metadata {
      annotations = {
        "autoscaling.knative.dev/maxScale" = 1
      }
    }
  }

  metadata {
    namespace = var.project_id
  }

  depends_on = [time_sleep.delay]
}

data "google_iam_policy" "noauth" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}

resource "google_cloud_run_service_iam_policy" "noauth" {
  location = google_cloud_run_service.vault_server.location
  project  = google_cloud_run_service.vault_server.project
  service  = google_cloud_run_service.vault_server.name

  policy_data = data.google_iam_policy.noauth.policy_data
}
