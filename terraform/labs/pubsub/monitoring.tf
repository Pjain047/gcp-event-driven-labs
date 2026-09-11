resource "google_monitoring_notification_channel" "alert_email" {
  project      = var.project_id
  display_name = "Orders DLQ Alert Email"
  type         = "email"

  labels = {
    email_address = var.alert_email
  }

  user_labels = {
    application = "orders-dlq-alert"
    environment = var.environment
    managed_by  = "terraform"
  }
}

resource "google_monitoring_alert_policy" "orders_dlq_alert" {
  project      = var.project_id
  display_name = "Orders DLQ Alert"
  combiner     = "OR"
  enabled      = true

  documentation {
    content   = <<-EOT
      Alert for messages waiting in the Orders dead-letter queue.

      Subscription: ${google_pubsub_subscription.orders_dlq.name}
      Dead-letter topic: ${google_pubsub_topic.orders_dlq.name}
      Project: ${var.project_id}
    EOT
    mime_type = "text/markdown"
  }

  conditions {
    display_name = "Orders DLQ Condition"
    condition_threshold {
      filter = join(" AND ", [
        "resource.type = \"pubsub_subscription\"",
        "resource.labels.subscription_id = \"${google_pubsub_subscription.orders_dlq.name}\"",
        "metric.type = \"pubsub.googleapis.com/subscription/num_undelivered_messages\"",
      ])
      comparison      = "COMPARISON_GT"
      threshold_value = 0
      duration        = "60s"

      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_MAX"
      }
      trigger {
        count = 1
      }

      evaluation_missing_data = "EVALUATION_MISSING_DATA_INACTIVE"
    }
  }
  notification_channels = [google_monitoring_notification_channel.alert_email.id]

  alert_strategy {
    auto_close = "3600s"

    notification_channel_strategy {
      notification_channel_names = [google_monitoring_notification_channel.alert_email.id]
      renotify_interval          = "3600s"
    }
  }

  user_labels = {
    application = "orders-dlq-alert"
    environment = var.environment
    managed_by  = "terraform"
  }
}