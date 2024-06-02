resource "google_kms_key_ring" "seal" {
  name     = "${var.name}seal"
  location = var.region
}

resource "google_kms_crypto_key" "seal" {
  name     = "${var.name}seal"
  key_ring = google_kms_key_ring.seal.id
}
