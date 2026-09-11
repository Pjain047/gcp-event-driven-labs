output "pubsub_topic_name" {
  description = "Name of the Pub/Sub topic."
  value       = google_pubsub_topic.orders.name
}

output "pubsub_topic_id" {
  description = "Fully qualified Pub/Sub topic ID."
  value       = google_pubsub_topic.orders.id
}

output "pubsub_subscription_name" {
  description = "Name of the primary Pub/Sub subscription."
  value       = google_pubsub_subscription.orders.name
}

output "pubsub_subscription_id" {
  description = "Fully qualified primary Pub/Sub subscription ID."
  value       = google_pubsub_subscription.orders.id
}

output "pubsub_dlq_topic_name" {
  description = "Name of the Pub/Sub dead-letter topic."
  value       = google_pubsub_topic.orders_dlq.name
}

output "pubsub_dlq_topic_id" {
  description = "Fully qualified Pub/Sub dead-letter topic ID."
  value       = google_pubsub_topic.orders_dlq.id
}

output "pubsub_dlq_subscription_name" {
  description = "Name of the dead-letter queue subscription."
  value       = google_pubsub_subscription.orders_dlq.name
}

output "pubsub_dlq_subscription_id" {
  description = "Fully qualified dead-letter queue subscription ID."
  value       = google_pubsub_subscription.orders_dlq.id
}

output "orders_dlq_alert_policy" {
  description = "Fully qualified Monitoring alert policy ID for the orders DLQ."
  value       = google_monitoring_alert_policy.orders_dlq_alert.id
}

output "orders_dlq_alert_email_channel" {
  description = "Fully qualified Monitoring notification channel ID for the orders DLQ."
  value       = google_monitoring_notification_channel.alert_email.id
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

output "pubsub_schema_name" {
  description = "Name of the Pub/Sub schema."
  value       = google_pubsub_schema.orders.name
}

output "pubsub_schema_id" {
  description = "Fully qualified Pub/Sub schema ID."
  value       = google_pubsub_schema.orders.id
}

output "pubsub_schema_revision_id" {
  description = "Revision ID of the Pub/Sub schema."
  value       = google_pubsub_schema.orders.revision_id
}
