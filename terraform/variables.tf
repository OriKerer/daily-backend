variable "project_id" {
  type        = string
  sensitive = true
  description = "The Google Cloud Project Id"
}

variable "region" {
  type    = string
  description = "Region to deploy regional resources"
}

variable "artifact_repository" {
  type = string
  description = "The name of the artifact to be used for storing container images"
}

variable "gcs_backend_bucket" {
  type    = string
  sensitive = true
  description = "The name of the bucket to be used as a terraform backend for remote state"
}