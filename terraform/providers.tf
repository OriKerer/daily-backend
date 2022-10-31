provider "google" {
  project = var.project_id
  region  = var.region
}

terraform {
  backend "gcs" {
    bucket = "daily-tfstate"
    prefix = "terraform/state"
  }
}
