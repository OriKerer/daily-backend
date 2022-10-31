variable "project_id" {
  type        = string
  sensitive   = true
  description = "The Google Cloud Project Id"
}

variable "region" {
  type        = string
  description = "Region to deploy regional resources"
}

variable "artifact_repository" {
  type        = string
  description = "The name of the artifact to be used for storing container images"
}

variable "daily_image_url" {
  type        = string
  description = "The url to daily container image"
}
