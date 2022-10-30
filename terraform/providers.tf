provider "google" {
  project = var.project_id
  region  = var.region
}

terraform {
  backend "gcs" {
    bucket = var.gcs_backend_bucket
    prefix = "terraform/state"
  }
}