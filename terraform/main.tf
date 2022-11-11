module "gce_container" {
  source  = "terraform-google-modules/container-vm/google"
  version = "~> 3.0"
}

resource "google_compute_instance" "daily" {
  name         = "daily"
  machine_type = "e2-micro"
  tags         = ["http-server", "https-server"]
  # metadata_startup_script   = data.template_file.startup_script.rendered
  allow_stopping_for_update = true
  description               = "VM to Host Daily container"

  boot_disk {
    initialize_params {
      image = module.gce_container.source_image
      type  = "pd-standard"
      size  = "10"
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
    billing      = daily-gce-instance
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

# resource "google_artifact_registry_repository_iam_member" "daily_gce_artifact_reader" {
#   location   = data.google_artifact_registry_repository.daily_artifact_repo.location
#   repository = data.google_artifact_registry_repository.daily_artifact_repo.name
#   role       = "roles/artifactregistry.reader"
#   member     = format("serviceAccount:%s", google_service_account.daily_gce.email)
# }

# resource "google_artifact_registry_repository_iam_binding" "binding" {
#   location   = data.google_artifact_registry_repository.daily_artifact_repo.location
#   repository = data.google_artifact_registry_repository.daily_artifact_repo.name
#   role       = "roles/artifactregistry.reader"
#   members = [
#     format("serviceAccount:%s", google_service_account.daily_gce.email),
#   ]
# }

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

# data "template_file" "startup_script" {
#   template = file("${path.module}/startup.sh.tpl")
#   vars = {
#     IMAGE          = var.daily_image_url
#     RESTART_POLICY = module.gce-container.restart_policy
#   }
# }

# resource "google_project_iam_policy" "daily_log_writer_policy" {
#   project     = var.project_id
#   policy_data = data.google_iam_policy.log_writer.policy_data
# }

# data "google_iam_policy" "log_writer" {
#   binding {
#     role = "roles/logging.logWriter"

#     members = [
#       format("serviceAccount:%s", google_service_account.daily_gce.email),
#     ]
#   }
# }

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
