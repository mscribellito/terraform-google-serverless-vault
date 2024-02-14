resource "google_storage_bucket" "vault_storage" {
  name     = "${var.name}-storage-${lower(random_id.random.hex)}"
  location = var.region

  depends_on = [time_sleep.delay]
}
