output "region" {
  description = "Region of the Vault service."
  value       = var.region
}

output "name" {
  description = "Name of the Vault service."
  value       = google_cloud_run_service.server.name
}

output "url" {
  description = "URL of the Vault service."
  value       = google_cloud_run_service.server.status[0].url
}
