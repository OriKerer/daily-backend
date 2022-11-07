# TODO: configure live migration?
#TODO: configure snapshots?

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

  boot_disk {
    initialize_params {
      image = module.gce-container.source_image
      type  = "pd-standard"
      size  = "10"
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

  tags = ["daily-api"]

  allow_stopping_for_update = true
  description               = "VM to Host Daily container"

  network_interface {
    subnetwork = google_compute_subnetwork.daily-subnet.self_link
  }

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.daily-gce.email
    scopes = ["cloud-platform"]
  }
}


resource "google_service_account" "daily-gce" {
  account_id   = "daily-gce"
  display_name = "Daily GCE service Account"
}
