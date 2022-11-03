variable "project_id" {
  type        = string
  sensitive   = true
  description = "The Google Cloud Project Id"
}

variable "region" {
  type        = string
  description = "Region to deploy regional resources"
}

variable "zone" {
  type        = string
  description = "Zone to deploy Zonal resources"
}

variable "daily_image_url" {
  type        = string
  description = "The url to daily container image"
}

variable "revision_name" {
  type = string
}
