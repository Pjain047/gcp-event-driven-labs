output "terraform_state_bucket" {
  value       = google_storage_bucket.terraform_state.name
  description = "The name of the Terraform state bucket"
}

output "terraform_state_bucket_url" {
  value       = google_storage_bucket.terraform_state.url
  description = "The URL of the Terraform state bucket"
}

output "terraform_backend_config" {
  description = "The name of the Terraform backend configuration bucket"
  value       = <<-EOT
    terraform {
      backend "gcs" {
        bucket = "${google_storage_bucket.terraform_state.name}"
        prefix = "terraform/state"
      }
    }
  EOT
}