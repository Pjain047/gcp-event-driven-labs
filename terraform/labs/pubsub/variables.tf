variable "project_id" {
  description = "Google Cloud project ID."
  type        = string
}

variable "region" {
  description = "Google Cloud deployment region."
  type        = string
  default     = "us-central1"
}

variable "environment" {
  description = "Deployment environment."
  type        = string
  default     = "dev"
}

variable "topic_name" {
  description = "Pub/Sub topic name."
  type        = string
  default     = "orders-topic"
}

variable "function_name" {
  description = "Cloud Run function name."
  type        = string
  default     = "process-order"
}

variable "function_runtime" {
  description = "Python runtime used by the function."
  type        = string
  default     = "python312"
}

variable "function_entry_point" {
  description = "Python function entry point."
  type        = string
  default     = "process_order"
}

variable "schema_name" {
  description = "Pub/Sub schema name."
  type        = string
  default     = "orders-schema"
}

variable "firestore_location" {
  description = "Location for the Firestore database."
  type        = string
  default     = "us-central1"
}

variable "alert_email" {
  description = "Email address for alert notifications."
  type        = string
}