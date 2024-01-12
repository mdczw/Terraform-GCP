variable "network_name" {
  type = string
}
variable "routing_mode" {
  default = "REGIONAL"
}

variable "subnets" {
  default = {}
  type = map(object({
    name          = string
    ip_cidr_range = string

  }))
}

variable "firewall_rules" {
  default = {}
  type = map(object({
    name          = string
    source_ranges = optional(list(string), [])
    source_tags   = optional(list(string))
    target_tags   = optional(list(string))

    allow = optional(list(object({
      protocol = string
      ports    = optional(list(string))
    })), [])
    deny = optional(list(object({
      protocol = string
      ports    = optional(list(string))
    })), [])
  }))
}
