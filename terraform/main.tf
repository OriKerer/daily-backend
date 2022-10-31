resource "google_cloud_run_service" "daily" {
  name     = "daily"
  location = var.region

  template {
    spec {
      containers {
        image = var.daily_image_url
      }
    }

    metadata {
      annotations = {
        "autoscaling.knative.dev/maxScale" = "1"
        "autoscaling.knative.dev/minScale" = "0"
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

resource "google_artifact_registry_repository" "container-images" {
  location      = var.region
  repository_id = var.artifact_repository
  description   = "Container images for daily"
  format        = "DOCKER"
}