output "pubsub_topic_name" {
  description = "Name of the Pub/Sub topic."
  value       = google_pubsub_topic.orders.name
}

output "pubsub_topic_id" {
  description = "Fully qualified Pub/Sub topic ID."
  value       = google_pubsub_topic.orders.id
}

output "function_name" {
  description = "Name of the deployed function."
  value       = google_cloudfunctions2_function.order_processor.name
}

output "function_location" {
  description = "Region of the deployed function."
  value       = google_cloudfunctions2_function.order_processor.location
}

output "function_runtime_service_account" {
  description = "Runtime service account used by the function."
  value       = google_service_account.function_runtime.email
}

output "function_source_bucket" {
  description = "Bucket containing the function ZIP archive."
  value       = google_storage_bucket.function_source.name
}
