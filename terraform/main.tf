module "gce_container" {
  source  = "terraform-google-modules/container-vm/google"
  version = "~> 3.0"
}

resource "google_compute_instance" "daily" {
  name                      = "daily"
  machine_type              = "e2-micro"
  tags                      = ["http-server", "https-server"]
  allow_stopping_for_update = true
  description               = "VM to Host Daily container"

  boot_disk {
    initialize_params {
      image = module.gce_container.source_image
      type  = "pd-standard"
      size  = "10"
    }
    labels = {
      billing = "daily-gce-boot-disk"
    }
  }

  metadata = {
    gce-container-declaration = <<EOF
      spec:
        containers:
        - name: daily
          image: us-east1-docker.pkg.dev/daily-7/container-images/daily
          stdin: true
          tty: true
          env:
            - name: GIN_MODE
              value: release
            - name: PORT
              value: 80
        restartPolicy: Always
        EOF
    google-logging-enabled    = "true"
    google-monitoring-enabled = "true"
  }

  labels = {
    container-vm = module.gce_container.vm_container_label
    billing      = "daily-gce-instance"
  }

  network_interface {
    subnetwork = google_compute_subnetwork.daily_subnet.self_link
    access_config {
      nat_ip = google_compute_address.daily_gce_external_ip.address
    }
  }

  service_account {
    email  = google_service_account.daily_gce.email
    scopes = ["cloud-platform"] # ["bigquery", "monitoring-write", "logging-write", "trace", "pubsub", "datastore"]
  }
}


resource "google_service_account" "daily_gce" {
  account_id   = "daily-gce"
  display_name = "Daily GCE service Account"
}

data "google_iam_policy" "daily_gce_artifact_reader" {
  binding {
    role = "roles/artifactregistry.reader"
    members = [
      format("serviceAccount:%s", google_service_account.daily_gce.email),
    ]
  }
}

resource "google_artifact_registry_repository_iam_policy" "daily_gce_artifact_reader" {
  location    = data.google_artifact_registry_repository.daily_artifact_repo.location
  repository  = data.google_artifact_registry_repository.daily_artifact_repo.name
  policy_data = data.google_iam_policy.daily_gce_artifact_reader.policy_data
}



data "google_artifact_registry_repository" "daily_artifact_repo" {
  location      = var.region
  repository_id = var.artifact_repository_name
}

resource "google_project_iam_binding" "daily_logs_writer" {
  project = var.project_id
  role    = "roles/logging.logWriter"

  members = [
    format("serviceAccount:%s", google_service_account.daily_gce.email),
  ]
}

resource "google_project_iam_binding" "daily_monitoring_metric_writer" {
  project = var.project_id
  role    = "roles/monitoring.metricWriter"

  members = [
    format("serviceAccount:%s", google_service_account.daily_gce.email),
  ]
}

#TODO: uptime checks 
#TODO: monitoring alerts
#TODO: monitoring dashboard
