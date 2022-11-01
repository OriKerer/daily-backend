variable "project_id" {
  type        = string
  sensitive   = true
  description = "The Google Cloud Project Id"
}

variable "region" {
  type        = string
  description = "Region to deploy regional resources"
}

variable "daily_image_url" {
  type        = string
  description = "The url to daily container image"
}

variable "latest_daily_image_digest" {
  type        = string
  description = "The digest of the latest image"
}
