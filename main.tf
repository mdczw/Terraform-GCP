terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.64.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

module "network" {
  source       = "./modules/network"
  network_name = format("%s-network", var.resource_prefix)
  subnets = {
    "subnet_a" = {
      name          = "${var.resource_prefix}-subnet"
      ip_cidr_range = var.subnet_ip_cidr_range
    }
  }
}

module "compute" {
  source     = "./modules/compute"
  network    = module.network.network_name
  subnetwork = module.network.subnet_names[0]
  region     = var.region
  zone       = var.zone
  project    = var.project_id

  temporary_instance_enabled                = var.temporary_instance_enabled
  instance_template_name                    = format("%s-instance-template", var.resource_prefix)
  instance_template_machine_type            = var.instance_template_machine_type
  instance_template_tags                    = var.instance_template_tags
  instance_template_metadata_startup_script = var.instance_template_metadata_startup_script

  image_name = format("%s-image", var.resource_prefix)

  instance_group_name               = format("%s-instance-group", var.resource_prefix)
  instance_group_base_instance_name = format("%s-instance", var.resource_prefix)
  instance_group_target_size        = var.instance_group_target_size
}

module "lb" {
  source          = "./modules/load_balancer"
  network         = module.network.network_name
  resource_prefix = var.resource_prefix
  instance_group  = module.compute.instance_group_name
}

resource "google_storage_bucket" "default" {
  name          = format("%s-bucket-tfstate", var.resource_prefix)
  force_destroy = false
  location      = var.region
  storage_class = "STANDARD"
}
