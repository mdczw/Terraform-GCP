project_id      = "gd-gcp-internship-devops"
region          = "us-central1"
zone            = "us-central1-c"
resource_prefix = "md-internship-sp"

subnet_ip_cidr_range = "10.0.2.0/24"
fw_source_tags       = ["allow-lb-service"]
fw_target_tags       = ["web"]
fw_protocol          = "tcp"
fw_ports             = ["80"]

instance_template_machine_type = "e2-micro"
instance_template_tags         = ["web", "allow-lb-service", "allow-health-check"]
instance_group_target_size     = 3

ip_address = ["89.64.40.117", ]
