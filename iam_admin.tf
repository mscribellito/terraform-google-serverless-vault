resource "google_service_account" "vault" {
  account_id = "${var.name}-sa"
}

resource "google_storage_bucket_iam_member" "object_admin" {
  bucket = google_storage_bucket.storage.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.vault.email}"
}

resource "google_secret_manager_secret_iam_member" "secret_accessor" {
  secret_id = google_secret_manager_secret.config.secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.vault.email}"
}

resource "google_kms_key_ring_iam_member" "crypto_key_encrypter_decrypter" {
  key_ring_id = google_kms_key_ring.seal.id
  role        = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member      = "serviceAccount:${google_service_account.vault.email}"
}

resource "google_kms_key_ring_iam_member" "viewer" {
  key_ring_id = google_kms_key_ring.seal.id
  role        = "roles/cloudkms.viewer"
  member      = "serviceAccount:${google_service_account.vault.email}"
}
