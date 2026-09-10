resource "random_id" "bucket_suffix" {
  byte_length = 4
}

resource "google_storage_bucket" "terraform_state" {
  project  = var.project_id
  name     = "${var.project_id}-${var.state_bucket_prefix}-${random_id.bucket_suffix.hex}"
  location = var.state_bucket_location

  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"

  versioning {
    enabled = true
  }

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      num_newer_versions = 10
      with_state         = "ARCHIVED"
    }
  }

  force_destroy = false

  labels = {
    environment = "bootstrap"
    purpose     = "terraform-state"
    application = "gcp-event-driven-labs"
    managed_by  = "terraform"
  }
}