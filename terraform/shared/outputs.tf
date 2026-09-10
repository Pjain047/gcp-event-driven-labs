output "github_service_account_email" {
  value       = google_service_account.github_developer.email
  description = "GitHub service account email"
}

output "workload_identity_provider" {
  value       = google_iam_workload_identity_pool_provider.github.name
  description = "GitHub workload identity provider"
}

output "workload_identity_pool" {
  value       = google_iam_workload_identity_pool.github.name
  description = "GitHub workload identity pool"
}
