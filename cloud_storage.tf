resource "random_id" "random" {
  byte_length = 2
}

resource "google_storage_bucket" "storage" {
  name     = "${var.name}storage-${random_id.random.hex}"
  location = var.region
}
