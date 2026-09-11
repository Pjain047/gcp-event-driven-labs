resource "google_service_account" "function_runtime" {
  project = var.project_id

  account_id = "order-processor-runtime"

  display_name = "Order Processor Runtime"
  description  = "Runtime identity for the order processor function."
}

resource "google_project_iam_member" "function_log_writer" {
  project = var.project_id
  role    = "roles/logging.logWriter"

  member = (
    "serviceAccount:${google_service_account.function_runtime.email}"
  )
}

resource "google_project_iam_member" "function_datastore_user" {
  project = var.project_id
  role    = "roles/datastore.user"

  member = (
    "serviceAccount:${google_service_account.function_runtime.email}"
  )
}
