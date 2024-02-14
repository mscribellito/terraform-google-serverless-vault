resource "google_service_account" "vault" {
  account_id   = "${var.name}-sa"
  display_name = "Vault Server Service Account"
}

resource "google_storage_bucket_iam_member" "storage_objectadmin" {
  bucket = google_storage_bucket.vault_storage.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.vault.email}"
}

resource "google_secret_manager_secret_iam_member" "secretmanager_secretaccessor" {
  secret_id = google_secret_manager_secret.vault_config.secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.vault.email}"
}

resource "google_kms_key_ring_iam_member" "cloudkms_cryptokeyencrypterdecrypter" {
  key_ring_id = google_kms_key_ring.vault_seal.id
  role        = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member      = "serviceAccount:${google_service_account.vault.email}"
}

resource "google_kms_key_ring_iam_member" "cloudkms_viewer" {
  key_ring_id = google_kms_key_ring.vault_seal.id
  role        = "roles/cloudkms.viewer"
  member      = "serviceAccount:${google_service_account.vault.email}"
}
