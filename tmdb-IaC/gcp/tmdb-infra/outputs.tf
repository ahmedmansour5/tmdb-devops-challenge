output "compute_ip1" {
  value = google_compute_instance.tmdb-instance.network_interface[0].access_config[0].nat_ip
}

output "compute_ip2" {
  value = google_compute_instance.tmdb-instance2.network_interface[0].access_config[0].nat_ip
}

output "lb_ip" {
  value = google_compute_forwarding_rule.tmdb_lb_forwarding_rule.ip_address
}