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

resource "google_compute_subnetwork" "lb_proxy_subnet" {
  ip_cidr_range = "10.0.3.0/24"
  name          = "lb-subnet"
  network       = google_compute_network.tmdb_network.id
  project       = var.project_id
  region        = var.region
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


# fw-allow-health-check. An ingress rule, applicable to the instances being load balanced, that allows all TCP traffic from the Google Cloud health checking systems (in 130.211.0.0/22 and 35.191.0.0/16). This example uses the target tag load-balanced-backend to identify the VMs that the firewall rule applies to

resource "google_compute_firewall" "tmdb-gcp-allow-rule" {
  name = "fw-allow-internal"
  allow {
    protocol = "tcp"
  }
  direction     = "INGRESS"
  network       = google_compute_network.tmdb_network.id
  priority      = 1000
  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]
  target_tags   = ["load-balanced-backend"]
}