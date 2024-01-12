#general
variable "network" {
  type = string
}
variable "subnetwork" {
  type = string
}
variable "zone" {
  type = string
}
variable "project" {
  type = string
}

#temporary instance
variable "temporary_instance_enabled" {
  type = bool
}
variable "temporary_instance_name" {
  type    = string
  default = "temp-vm"
}
variable "temporary_instance_machine_type" {
  type    = string
  default = "e2-micro"
}
variable "temporary_instance_image" {
  type    = string
  default = "debian-cloud/debian-10"
}
variable "temporary_instance_metadata_startup_script" {
  default = <<-EOF1
      #! /bin/bash
      sudo apt update
      sudo apt install -y apache2
      echo "<html><body><h1>A simple website</h1></body></html>" > /var/www/html/index.html
  EOF1
}

#image
variable "image_name" {
  type = string
}

#instance template
variable "instance_template_name" {
  type    = string
  default = "instance-template"
}
variable "region" {
  type = string
}
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
  default = ""
}

#instance group
variable "instance_group_name" {
  type    = string
  default = "instance-group"
}
variable "instance_group_base_instance_name" {
  type    = string
  default = "instance"
}
variable "instance_group_target_size" {
  type = number
}
variable "instance_group_target_pools" {
  type    = list(string)
  default = []
}
variable "health_check_name" {
  type    = string
  default = "default_health_check"
}
variable "health_check_port" {
  type    = number
  default = 80
}
variable "mig_port_name" {
  default = "http"
}
variable "mig_port" {
  default = 80
}