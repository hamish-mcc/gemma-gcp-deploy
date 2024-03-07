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
  project = var.project_id
  location = var.zone

  initial_node_count = 1

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  release_channel {
    channel = "RAPID"
  }

  node_config {
    machine_type = "e2-standard-4"
  }

  deletion_protection = false
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name = "gpupool"
  project = var.project_id
  location = var.zone
  cluster    = google_container_cluster.primary.id

  node_count = 1

  node_config {
    machine_type = "g2-standard-12"

    guest_accelerator {
      type = "nvidia-l4"
      count = 1
      gpu_driver_installation_config {
        gpu_driver_version = "LATEST"
      }
    }
  }
}

