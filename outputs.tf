output "region" {
  description = "Region of the Vault Cloud Run service."
  value       = var.region
}

output "service_name" {
  description = "Name of the Vault Cloud Run service."
  value       = google_cloud_run_service.vault_server.name
}

output "service_url" {
  description = "URL of the Vault Cloud Run service."
  value       = google_cloud_run_service.vault_server.status[0].url
}
