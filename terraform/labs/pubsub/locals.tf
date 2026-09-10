locals {
  function_source_directory = (
    "${path.module}/../../../functions/order-processor"
  )

  function_archive_path = (
    "${path.module}/function-source.zip"
  )

  common_labels = {
    application = "order-processing"
    environment = var.environment
    managed-by  = "terraform"
    lab         = "pubsub"
  }
}
