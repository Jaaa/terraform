variable "create_vpc" {
  description = ""
  type        = bool
}

variable "azs" {
  description = ""
  type        = list(string)
}

variable "vpc_cidr" {
  description = "CIDR range of the VPC"
  type        = string
}

variable "instance_tenancy" {
  description = ""
  type        = string
  default     = "default"
}

variable "enable_dns_support" {
  description = ""
  type        = bool
  default     = true
}

variable "enable_dns_hostnames" {
  description = ""
  type        = bool
  default     = false
}

variable "enable_network_usage_metrics" {
  description = ""
  type        = bool
  default     = false
}

variable "vpc_tags" {
  description = ""
  type        = map(string)
}

# Subnet Variables

variable "public_subnet_cidr" {
  description = ""
  type        = list(string)
}

variable "public_enable_dns64" {
  description = ""
  type        = bool
  default     = false
}

variable "public_enable_aaaa_record" {
  description = ""
  type        = bool
  default     = false
}

variable "public_enable_a_record" {
  description = ""
  type        = bool
  default     = false
}

variable "public_map_on_launch" {
  description = ""
  type        = bool
  default     = false
}

# variable "public_map_customer_owned_ip_on_launch" {
#   description = ""
#   type = string
#   default = ""
# }

# variable "public_customer_owned_ipv4_pool" {
#   description = ""
#   type = string
#   default = ""
# }

variable "public_subnet_tags" {
  description = ""
  type        = map(string)
}


variable "private_subnet_cidr" {
  description = ""
  type        = list(string)
}

variable "private_enable_dns64" {
  description = ""
  type        = bool
  default     = false
}

variable "private_enable_aaaa_record" {
  description = ""
  type        = bool
  default     = false
}

variable "private_enable_a_record" {
  description = ""
  type        = bool
  default     = false
}

variable "private_map_ip_on_launch" {
  description = ""
  type        = bool
  default     = false
}

variable "private_subnet_tags" {
  description = ""
  type        = map(string)
}

# IGW Variables

variable "igw_tags" {
  description = ""
  type        = map(string)
  default     = {}
}

# NGW Variables

variable "connectivity_type" {
  description = ""
  type        = string
}

variable "create_ngw" {
  description = ""
  type        = bool
}