module "gce-container" {
  source  = "terraform-google-modules/container-vm/google"
  version = "~> 3.0"

  container = {
    image = var.daily_image_url
    env = [
      {
        name  = "GIN_MODE"
        value = "release"
      }
    ]
  }

  restart_policy = "always"
}

resource "google_compute_instance" "default" {
  name         = "daily"
  machine_type = "e2-micro"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = module.gce-container.source_image
      labels = {
        my_label = "value"
      }
    }
  }

  metadata = {
    gce-container-declaration = module.gce-container.metadata_value
    google-logging-enabled    = "true"
    google-monitoring-enabled = "true"
  }

  labels = {
    container-vm = module.gce-container.vm_container_label
  }
  allow_stopping_for_update = true
  description               = "VM to Host Daily container"

  network_interface { #TODO: VPC network
    network = "default"

    access_config {
      network_tier = "STANDARD"
    }
  }


  resource "google_service_account" "default" { # TODO: Service account
    account_id   = "service_account_id"
    display_name = "Service Account"
  }
  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.default.email
    scopes = ["cloud-platform"]
  }
}
