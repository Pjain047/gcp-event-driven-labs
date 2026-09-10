variable "project_id" {
  description = "The ID of the project in which to create resources."
  type        = string
}

variable "region" {
  description = "The region in which to create resources."
  type        = string
}

variable "state_bucket_location" {
  description = "The location of the state bucket."
  type        = string
  default     = "US"
}

variable "state_bucket_prefix" {
  description = "The prefix of the state bucket."
  type        = string
  default     = "gcp-event-lab-tfstate"
}
