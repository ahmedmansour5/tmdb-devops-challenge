# This creates a tmdb network with 2 subnetworks [App / LB] + Firewall rules
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork

resource "google_compute_network" "tmdb_network" {
  name                    = "tmdb-network"
  project                 = var.project_id
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "tmdb_app_subnet" {
  name          = "app-subnet"
  ip_cidr_range = "10.0.1.0/24"
  region        = var.region
  network       = google_compute_network.tmdb_network.id
}

resource "google_compute_subnetwork" "tmdb_lb_subnet" {
  name          = "lb-subnet"
  ip_cidr_range = "10.0.2.0/24"
  region        = var.region
  network       = google_compute_network.tmdb_network.id
}

resource "google_compute_firewall" "ssh" {
  name = "allow-ssh"
  allow {
    ports    = ["22"]
    protocol = "tcp"
  }
  direction     = "INGRESS"
  network       = google_compute_network.tmdb_network.id
  priority      = 1000
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["tmdb", "ssh"]
}

resource "google_compute_firewall" "http" {
  name = "allow-http"
  allow {
    ports    = ["80"]
    protocol = "tcp"
  }
  direction     = "INGRESS"
  network       = google_compute_network.tmdb_network.id
  priority      = 1000
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["tmdb", "http"]
}