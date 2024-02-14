terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.31.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_project_service" "enable_apis_services" {
  for_each           = toset(var.apis_services)
  service            = each.value
  disable_on_destroy = false
}

resource "time_sleep" "delay" {
  depends_on      = [google_project_service.enable_apis_services]
  create_duration = "60s"
}

resource "random_id" "random" {
  byte_length = 4
}
