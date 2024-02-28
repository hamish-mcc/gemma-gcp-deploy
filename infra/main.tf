terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "5.18.0"
    }
  }
}

provider "google" {
  credentials = file("${var.gcp_credentials_path}")

  project = var.project_id
  region  = var.region
  zone    = var.zone
}

resource "google_container_cluster" "primary" {
  name     = "triton"
  location = var.region

  release_channel {
    channel = "RAPID"
  }

  addons_config {
    http_load_balancing {
      disabled = false
    }
  }

  allow_net_admin = true

  min_master_version = "1.28"

  enable_autopilot = true

  deletion_protection = false
}


