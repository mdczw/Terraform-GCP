resource "google_compute_network" "network" {
  name                    = var.network_name
  routing_mode            = var.routing_mode
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnetwork" {
  for_each      = var.subnets
  name          = each.value.name
  ip_cidr_range = each.value.ip_cidr_range
  network       = google_compute_network.network.self_link
  depends_on    = [google_compute_network.network]
}

resource "google_compute_firewall" "rules" {
  for_each      = var.firewall_rules
  name          = each.value.name
  network       = google_compute_network.network.self_link
  source_ranges = each.value.source_ranges
  source_tags   = each.value.source_tags
  target_tags   = each.value.target_tags

  dynamic "allow" {
    for_each = lookup(each.value, "allow", [])
    content {
      protocol = allow.value.protocol
      ports    = lookup(allow.value, "ports", null)
    }
  }
  depends_on = [google_compute_network.network]
}