resource "google_project_service" "enable_apis" {
  for_each = toset(local.apis)
  project  = var.project_id
  service  = each.value

  disable_on_destroy = false
}

data "google_project" "current" {
  project_id = var.project_id
}

resource "google_service_account" "github_developer" {
  account_id   = "github-developer"
  display_name = "GitHub Actions Deployer"
  project      = var.project_id
}

resource "google_project_iam_member" "github_roles" {
  for_each = toset(local.deployer_roles)
  project  = var.project_id
  role     = each.value
  member   = "serviceAccount:${google_service_account.github_developer.email}"
}

resource "google_iam_workload_identity_pool" "github" {
  workload_identity_pool_id = "github-pool"
  display_name              = "GitHub wid Pool"
  description               = "Workload Identity Pool for GitHub Actions"
}

resource "google_iam_workload_identity_pool_provider" "github" {
  workload_identity_pool_id = google_iam_workload_identity_pool.github.workload_identity_pool_id

  workload_identity_pool_provider_id = "github-provider"

  display_name = "GitHub Actions Provider"
  description  = "Workload Identity Pool Provider for GitHub Actions"

  attribute_mapping = {
    "google.subject"       = "assertion.sub"
    "attribute.repository" = "assertion.repository"
  }

  attribute_condition = "assertion.repository == '${var.github_owner}/${var.github_repo}'"

  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
}

resource "google_service_account_iam_member" "github_wif_binding" {
  service_account_id = google_service_account.github_developer.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/projects/${data.google_project.current.number}/locations/global/workloadIdentityPools/${google_iam_workload_identity_pool.github.workload_identity_pool_id}/attribute.repository/${var.github_owner}/${var.github_repo}"
}
