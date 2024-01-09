resource "google_compute_instance" "temporary_instance" {
  name         = var.temporary_instance_name
  machine_type = var.temporary_instance_machine_type
  boot_disk {
    initialize_params {
      image = var.temporary_instance_image
    }
  }
  metadata = {
    startup-script = var.temporary_instance_metadata_startup_script
  }
  network_interface {
    network    = var.network
    subnetwork = var.subnetwork
    access_config {
    }
  }
  provisioner "local-exec" {
    command = "gcloud compute instances stop ${self.name} --zone=${self.zone} --quiet"
  }
}

resource "google_compute_image" "image" {
  name        = var.image_name
  source_disk = google_compute_instance.temporary_instance.self_link
  depends_on  = [google_compute_instance.temporary_instance]
}

resource "google_compute_instance_template" "instance_template" {
  name         = var.instance_template_name
  machine_type = var.instance_template_machine_type
  tags         = var.instance_template_tags
  region       = var.region
  disk {
    source_image = google_compute_image.image.self_link
  }
  network_interface {
    network    = var.network
    subnetwork = var.subnetwork
    access_config {
    }
  }
  metadata_startup_script = var.instance_template_metadata_startup_script
  depends_on              = [google_compute_image.image]
}

resource "google_compute_instance_group_manager" "instance_group" {
  name = var.instance_group_name
  named_port {
    name = "http"
    port = 80
  }
  version {
    instance_template = google_compute_instance_template.instance_template.self_link
  }
  base_instance_name = var.instance_group_base_instance_name
  target_size        = var.instance_group_target_size
  depends_on         = [google_compute_instance_template.instance_template]
}

