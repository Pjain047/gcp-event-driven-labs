data "archive_file" "function_source" {
  type        = "zip"
  source_dir  = local.function_source_directory
  output_path = local.function_archive_path

  excludes = [
    "__pycache__",
    ".venv",
    ".pytest_cache",
    "tests",
  ]
}

resource "random_id" "source_bucket_suffix" {
  byte_length = 4
}

resource "google_storage_bucket" "function_source" {
  project = var.project_id

  name = (
    "${var.project_id}-function-source-${random_id.source_bucket_suffix.hex}"
  )

  location = var.region

  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"
  force_destroy               = true

  lifecycle_rule {
    condition {
      age = 7
    }

    action {
      type = "Delete"
    }
  }

  labels = local.common_labels
}

resource "google_storage_bucket_object" "function_source" {
  name = (
    "order-processor/function-${data.archive_file.function_source.output_md5}.zip"
  )

  bucket = google_storage_bucket.function_source.name
  source = data.archive_file.function_source.output_path
}

resource "google_pubsub_topic" "orders" {
  project = var.project_id
  name    = var.topic_name

  labels = local.common_labels

  message_retention_duration = "86600s"
}


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

resource "google_cloudfunctions2_function" "order_processor" {
  project  = var.project_id
  name     = var.function_name
  location = var.region

  description = (
    "Processes order events received from Pub/Sub."
  )

  build_config {
    runtime     = var.function_runtime
    entry_point = var.function_entry_point

    source {
      storage_source {
        bucket = google_storage_bucket.function_source.name
        object = google_storage_bucket_object.function_source.name
      }
    }
  }

  service_config {
    available_memory = "256M"
    available_cpu    = "1"

    timeout_seconds = 60

    min_instance_count = 0
    max_instance_count = 3

    max_instance_request_concurrency = 1

    service_account_email = (
      google_service_account.function_runtime.email
    )

    environment_variables = {
      APP_ENVIRONMENT = var.environment
      LOG_LEVEL       = "INFO"
    }
  }

  event_trigger {
    trigger_region = var.region
    event_type     = "google.cloud.pubsub.topic.v1.messagePublished"

    pubsub_topic = google_pubsub_topic.orders.id

    retry_policy = "RETRY_POLICY_RETRY"
  }

  labels = local.common_labels

  depends_on = [
    google_project_iam_member.function_log_writer,
  ]
}

