variable "project_id" {
  type        = string
  description = "The Google Cloud Project Id"
}

variable "region" {
  type    = string
  description = "Region to deploy regional resources"
}

variable "gcs_backend_bucket" {
  type    = string
  description = "The name of the bucket to be used as a terraform backend for remote state"
}