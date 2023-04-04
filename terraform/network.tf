resource "google_compute_network" "daily_network" {
  name                    = "daily-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "daily_subnet" {
  name                     = "daily-subnet"
  ip_cidr_range            = "10.1.0.0/24"
  network                  = google_compute_network.daily_network.id
  private_ip_google_access = true
}

resource "google_compute_firewall" "http_server" {
  # TODO: disable after testing
  name        = "http-server"
  network     = google_compute_network.daily_network.self_link
  description = "Allow HTTP traffic"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server"]
}

resource "google_compute_firewall" "https_server" {
  name        = "https-server"
  network     = google_compute_network.daily_network.self_link
  description = "Allow HTTPs traffic"

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["https-server"]
}

resource "google_compute_firewall" "iap_ssh" {
  name        = "iap-ssh"
  network     = google_compute_network.daily_network.self_link
  description = "Allow ssh traffic for daily instance from IAP IPs range"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["35.235.240.0/20"]
  target_tags   = ["http-server", "https-server"]
}

resource "google_compute_address" "daily_gce_external_ip" {
  name         = "daily-gce-external-ip"
  address_type = "EXTERNAL"
}
