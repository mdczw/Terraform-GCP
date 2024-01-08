output "ip" {
  value = module.lb.ip_address
}
output "storage_bucket" {
  value = google_storage_bucket.default.name
}