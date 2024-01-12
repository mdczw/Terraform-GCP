#General
variable "resource_prefix" {
  type = string
}
variable "network" {
}

#Forwarding rule
variable "forwarding_rule_ip_protocol" {
  default = "TCP"
}
variable "load_balancing_scheme" {
  default = "EXTERNAL"
}
variable "forwarding_rule_port_range" {
  default = "80"
}

#Backend service
variable "backend_service_protocol" {
  default = "HTTP"
}
variable "backend_service_port_name" {
  default = "http"
}
variable "backend_service_timeout_sec" {
  default = 10
}
variable "instance_group" {
}
variable "backend_service_balancing_mode" {
  default = "UTILIZATION"
}
variable "backend_service_capacity_scaler" {
  default = 1.0
}

#Health check
variable "health_check_port_specification" {
  default = "USE_SERVING_PORT"
}