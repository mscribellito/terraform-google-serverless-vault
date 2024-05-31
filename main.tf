terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.31.1"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

resource "random_id" "random" {
  byte_length = 2
}
