terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.51.0"
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
  name     = "${var.project_id}-gke"
  location = var.region

  release_channel {
    channel = "RAPID"
  }

  min_master_version = "1.28"

  enable_autopilot = true
}


