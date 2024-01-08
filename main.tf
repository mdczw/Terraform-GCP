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
  network_name = "${var.resource_prefix}-network"
  subnets = [
    {
      name          = "${var.resource_prefix}-subnet"
      ip_cidr_range = var.subnet_ip_cidr_range
    },
  ]
}

module "compute" {
  source     = "./modules/compute"
  network    = module.network.network_name
  subnetwork = module.network.subnet_names[0]
  image_name = "${var.resource_prefix}-image"
  region     = var.region

  instance_template_name                    = "${var.resource_prefix}-instance-template"
  instance_template_machine_type            = var.instance_template_machine_type
  instance_template_tags                    = var.instance_template_tags
  instance_template_metadata_startup_script = var.instance_template_metadata_startup_script

  instance_group_name               = "${var.resource_prefix}-instance-group"
  instance_group_base_instance_name = "${var.resource_prefix}-instance"
  instance_group_target_size        = var.instance_group_target_size
}

module "lb" {
  source                           = "./modules/load_balancer"
  network                          = module.network.network_name
  instance_group                   = module.compute.instance_group_name
}

resource "google_storage_bucket" "default" {
  name          = "${var.resource_prefix}-bucket-tfstate"
  force_destroy = false
  location      = var.region
  storage_class = "STANDARD"
}
