output "network_name" {
  value = google_compute_network.network.name
}
output "subnet_names" {
  value = [for subnetwork in google_compute_subnetwork.subnetwork : subnetwork.name]

}