resource "google_kms_key_ring" "vault_seal" {
  name     = "${var.name}-seal"
  location = var.region

  depends_on = [time_sleep.delay]
}

resource "google_kms_crypto_key" "vault_seal" {
  name     = "${var.name}-seal"
  key_ring = google_kms_key_ring.vault_seal.id
}
