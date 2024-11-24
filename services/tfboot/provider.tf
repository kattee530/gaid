terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0.0"
    }
  }
}

provider "google" {
  add_terraform_attribution_label = false
  default_labels = {
    created_by = "terraform"
  }
}
