variable "gcp_credentials_path" {
    description = "Path to GCP credentials JSON file"
    type = string
}

variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The GCP region where resources be created"
  type        = string
}

variable "zone" {
  description = "The zone within the GCP region where resources be created"
  type        = string
}

