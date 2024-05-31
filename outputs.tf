output "url" {
  description = "URL of the Vault Cloud Run service."
  value       = google_cloud_run_service.server.status[0].url
}
