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
