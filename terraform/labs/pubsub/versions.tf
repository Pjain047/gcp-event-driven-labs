terraform {
  required_version = ">= 1.7.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 7.0, < 9.0"
    }

    archive = {
      source  = "hashicorp/archive"
      version = ">= 2.7, < 3.0"
    }

    random = {
      source  = "hashicorp/random"
      version = ">= 3.7, < 4.0"
    }
  }
}