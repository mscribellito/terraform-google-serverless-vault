resource "google_storage_bucket" "storage" {
  name     = "${var.name}-storage-${random_id.random.hex}"
  location = var.region
}
