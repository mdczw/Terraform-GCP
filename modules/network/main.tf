resource "google_compute_network" "network" {
  name                    = var.network_name
  routing_mode            = var.routing_mode
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnetwork" {
  for_each      = length(var.subnets) > 0 ? { for r in var.subnets : r.name => r } : {}
  name          = each.value.name
  ip_cidr_range = each.value.ip_cidr_range
  network       = google_compute_network.network.self_link
  depends_on    = [google_compute_network.network]
}

resource "google_compute_firewall" "rules" {
  for_each      = length(var.firewall_rules) > 0 ? { for r in var.firewall_rules : r.name => r } : {}
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