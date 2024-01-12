project_id      = "gd-gcp-internship-devops"
region          = "us-central1"
zone            = "us-central1-c"
resource_prefix = "md-internship-sp"

subnet_ip_cidr_range = "10.0.2.0/24"

temporary_instance_enabled     = false
instance_template_machine_type = "e2-micro"
instance_template_tags         = ["allow-health-check", "web"]
instance_group_target_size     = 3
