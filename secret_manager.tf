resource "google_secret_manager_secret" "vault_config" {
  secret_id = "${var.name}-config"
  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }

  depends_on = [time_sleep.delay]
}

resource "google_secret_manager_secret_version" "vault_config" {
  secret = google_secret_manager_secret.vault_config.id
  secret_data = templatefile("${path.module}/templates/config.json",
    {
      ui         = var.vault_ui
      log_level  = var.vault_log_level
      project    = var.project_id
      region     = var.region
      key_ring   = google_kms_key_ring.vault_seal.name
      crypto_key = google_kms_crypto_key.vault_seal.name
      bucket     = google_storage_bucket.vault_storage.name
    }
  )
}
