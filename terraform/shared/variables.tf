variable "project_id" {
  description = "The ID of the project in which to create resources."
  type        = string
}

variable "region" {
  description = "The region in which to create resources."
  type        = string
}

variable "github_owner" {
  description = "The GitHub owner or organization for the repository."
  type        = string
}

variable "github_repo" {
  description = "The name of the GitHub repository."
  type        = string
}