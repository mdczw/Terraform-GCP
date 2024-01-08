#General
variable "project_id" {
  type = string
}
variable "region" {
  type    = string
  default = "us-central1"
}
variable "zone" {
  type    = string
  default = "us-central1-c"
}
variable "resource_prefix" {
  type = string
}

#Network
variable "subnet_ip_cidr_range" {
  type    = string
  default = "10.0.0.0/24"
}
variable "fw_source_tags" {
  type    = list(string)
  default = []
}
variable "fw_target_tags" {
  type    = list(string)
  default = []
}
variable "fw_protocol" {
  type    = string
  default = "tcp"
}
variable "fw_ports" {
  type    = list(string)
  default = []
}

#Compute
variable "instance_template_machine_type" {
  type    = string
  default = "e2-micro"
}
variable "instance_template_tags" {
  type    = list(string)
  default = []
}
variable "instance_template_metadata_startup_script" {
  type    = string
  default = "hostname >> /var/www/html/index.html"
}
variable "instance_group_target_size" {
  type = number
}

#load balancer
