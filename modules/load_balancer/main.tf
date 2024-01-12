resource "google_compute_global_address" "default" {
  name         = format("%s-lb-static-ip-address", var.resource_prefix)
  address_type = "EXTERNAL"
}
resource "google_compute_global_forwarding_rule" "default" {
  name                  = format("%s-forwarding-rule", var.resource_prefix)
  ip_protocol           = var.forwarding_rule_ip_protocol
  load_balancing_scheme = var.load_balancing_scheme
  port_range            = var.forwarding_rule_port_range
  target                = google_compute_target_http_proxy.default.id
  ip_address            = google_compute_global_address.default.id
}
resource "google_compute_target_http_proxy" "default" {
  name    = format("%s-target-http-proxy", var.resource_prefix)
  url_map = google_compute_url_map.default.id
}
resource "google_compute_url_map" "default" {
  name            = format("%s-url-map", var.resource_prefix)
  default_service = google_compute_backend_service.default.id
}

resource "google_compute_backend_service" "default" {
  name                  = format("%s-lb-backend-service", var.resource_prefix)
  protocol              = var.backend_service_protocol
  port_name             = var.backend_service_port_name
  load_balancing_scheme = var.load_balancing_scheme
  timeout_sec           = var.backend_service_timeout_sec
  health_checks         = [google_compute_health_check.default.id]
  backend {
    group           = var.instance_group
    balancing_mode  = var.backend_service_balancing_mode
    capacity_scaler = var.backend_service_capacity_scaler
  }
}
resource "google_compute_health_check" "default" {
  name = format("%s-lb-health-check", var.resource_prefix)
  http_health_check {
    port_specification = var.health_check_port_specification
  }
}

resource "google_compute_firewall" "default" {
  name          = format("%s-lb-fw-allow-hc", var.resource_prefix)
  direction     = "INGRESS"
  network       = var.network
  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]
  allow {
    protocol = "tcp"
  }
  target_tags = ["allow-health-check"]
}
