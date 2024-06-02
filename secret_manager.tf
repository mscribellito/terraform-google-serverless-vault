resource "google_secret_manager_secret" "config" {
  secret_id = "${var.name}config"
  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}

resource "google_secret_manager_secret_version" "config" {
  secret = google_secret_manager_secret.config.id
  secret_data = templatefile("${path.module}/templates/config.json",
    {
      ui         = var.ui
      log_level  = var.log_level
      project    = var.project_id
      region     = var.region
      key_ring   = google_kms_key_ring.seal.name
      crypto_key = google_kms_crypto_key.seal.name
      bucket     = google_storage_bucket.storage.name
    }
  )
}
