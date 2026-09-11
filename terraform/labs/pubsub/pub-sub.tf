resource "google_pubsub_schema" "orders" {
  project = var.project_id
  name    = var.schema_name

  type       = "PROTOCOL_BUFFER"
  definition = file("${path.module}/schema/order_created.proto")
}


resource "google_pubsub_topic" "orders" {
  project = var.project_id
  name    = var.topic_name

  labels = local.common_labels

  message_retention_duration = "86600s"

  schema_settings {
    schema   = google_pubsub_schema.orders.id
    encoding = "JSON"
  }

  depends_on = [google_pubsub_schema.orders]
}

resource "google_pubsub_topic" "orders_dlq" {
  project = var.project_id
  name    = "${var.topic_name}-dlq"

  labels = local.common_labels

  message_retention_duration = "86600s"
}

resource "google_pubsub_subscription" "orders" {
  project = var.project_id
  name    = "${var.topic_name}-subscription"
  topic   = google_pubsub_topic.orders.id

  dead_letter_policy {
    dead_letter_topic     = google_pubsub_topic.orders_dlq.id
    max_delivery_attempts = 5
  }

  depends_on = [google_pubsub_topic.orders, google_pubsub_topic.orders_dlq]
}

resource "google_pubsub_subscription" "orders_dlq" {
  project = var.project_id
  name    = "${var.topic_name}-dlq-subscription"
  topic   = google_pubsub_topic.orders_dlq.id

  message_retention_duration = "86600s"

  depends_on = [google_pubsub_topic.orders_dlq]
}
