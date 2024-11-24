terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0.0"
    }
  }
}

provider "google" {
  alias = "impersonation"
  scopes = [
    "https://www.googleapis.com/auth/cloud-platform",
    "https://www.googleapis.com/auth/userinfo.email",
  ]
}

data "google_service_account_access_token" "tfadm" {
  provider               = google.impersonation
  target_service_account = google_service_account.tf-sva-tfboot-prd-glb-tfadm-001.email
  scopes                 = ["userinfo-email", "cloud-platform"]
  lifetime               = "1200s"
}

provider "google" {
  add_terraform_attribution_label = false
  default_labels = {
    created_by      = "terraform"
    access_token    = data.google_service_account_access_token.tfadm.access_token
    request_timeout = "60s"
  }
}