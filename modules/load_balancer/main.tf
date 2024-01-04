resource "google_compute_global_address" "default" {
  name         = "xlb-static-ip-address"
  address_type = "EXTERNAL"
}
resource "google_compute_global_forwarding_rule" "default" {
  name                  = "xlb-forwarding-rule"
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL"
  port_range            = "80"
  target                = google_compute_target_http_proxy.default.id
  ip_address            = google_compute_global_address.default.id
}
resource "google_compute_target_http_proxy" "default" {
  name    = "test-proxy-health-check"
  url_map = google_compute_url_map.default.id
}
resource "google_compute_url_map" "default" {
  name            = "xlb-url-map"
  default_service = google_compute_backend_service.default.id
}

resource "google_compute_backend_service" "default" {
  name                  = "xlb-backend-service"
  protocol              = "HTTP"
  port_name             = "http"
  load_balancing_scheme = "EXTERNAL"
  timeout_sec           = 10
  health_checks         = [google_compute_health_check.default.id]
  backend {
    group           = var.instance_group
    balancing_mode  = "UTILIZATION"
    capacity_scaler = 1.0
  }
}
resource "google_compute_health_check" "default" {
  name = "tcp-proxy-health-check"
  http_health_check {
    port_specification = "USE_SERVING_PORT"
  }
}

resource "google_compute_firewall" "default" {
  name          = "tcp-proxy-xlb-fw-allow-hc"
  direction     = "INGRESS"
  network       = var.network
  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]
  allow {
    protocol = "tcp"
  }
  target_tags = ["allow-health-check"]
}
