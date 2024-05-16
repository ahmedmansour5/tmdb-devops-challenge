resource "google_compute_region_backend_service" "tmdb-backend" {
  connection_draining_timeout_sec = 300
  health_checks                   = [google_compute_region_health_check.http_health.id]
  load_balancing_scheme           = "EXTERNAL_MANAGED"
  locality_lb_policy              = "ROUND_ROBIN"
  name                            = "tmdb-backend"
  port_name                       = "http"
  project                         = var.project_id
  protocol                        = "HTTP"
  backend {
    group           = google_compute_instance_group.instance_group_1.id
    balancing_mode  = "UTILIZATION"
    capacity_scaler = 1.0
  }
  region           = var.region
  session_affinity = "NONE"
  timeout_sec      = 30
}

resource "google_compute_region_url_map" "tmdb_lb" {
  default_service = google_compute_region_backend_service.tmdb-backend.id
  name            = "tmdb-lb"
  project         = var.project_id
  region          = var.region
}

resource "google_compute_instance_group" "instance_group_1" {
  instances = [google_compute_instance.tmdb-instance.id, google_compute_instance.tmdb-instance2.id]
  name      = "instance-group"

  named_port {
    name = "http"
    port = 80
  }

  network = google_compute_network.tmdb_network.id
  project = var.project_id
  zone    = var.zone
}

resource "google_compute_region_health_check" "http_health" {
  check_interval_sec = 5
  healthy_threshold  = 2

  http_health_check {
    port         = 80
    proxy_header = "NONE"
    request_path = "/"
  }

  name                = "http-health"
  project             = var.project_id
  region              = var.region
  timeout_sec         = 5
  unhealthy_threshold = 2
}

resource "google_compute_forwarding_rule" "tmdb_lb_forwarding_rule" {
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  name                  = "tmdb-lb-forwarding-rule"
  network               = google_compute_network.tmdb_network.id
  network_tier          = "STANDARD"
  port_range            = "80-80"
  project               = var.project_id
  region                = var.region
  target                = google_compute_region_target_http_proxy.tmdb_lb_target_proxy.id
}

resource "google_compute_region_target_http_proxy" "tmdb_lb_target_proxy" {
  name    = "tmdb-lb-target-proxy"
  project = var.project_id
  region  = var.region
  url_map = google_compute_region_url_map.tmdb_lb.id
}