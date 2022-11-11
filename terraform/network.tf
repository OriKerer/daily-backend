
resource "google_compute_network" "daily-network" {
  name                    = "daily-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "daily-subnet" {
  name                     = "daily-subnet"
  ip_cidr_range            = "10.2.0.0/16" # TODO: decide cidr block
  network                  = google_compute_network.daily-network.id
  private_ip_google_access = true
}

resource "google_compute_firewall" "daily-http" {
  # TODO: disable after testing
  name        = "daily-http"
  network     = google_compute_network.daily-network.self_link
  description = "Allow HTTP traffic for daily backend APIs"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["daily-api"]
}

resource "google_compute_firewall" "daily-https" {
  name        = "daily-https"
  network     = google_compute_network.daily-network.self_link
  description = "Allow HTTPs traffic for daily backend APIs"

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["daily-api"]
}

resource "google_compute_firewall" "iap-ssh" {
  name        = "iap-ssh"
  network     = google_compute_network.daily-network.self_link
  description = "Allow ssh traffic for daily instance from IAP IPs range"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["35.235.240.0/20"]
  target_tags   = ["daily-api"]
}

resource "google_compute_address" "daily-gce-external-ip" {
  name         = "daily-gce-external-ip"
  address_type = "EXTERNAL"
}
