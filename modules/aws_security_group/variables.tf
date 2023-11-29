variable "sg_description" {
  description = ""
  type        = string
}

variable "sg_name" {
  description = ""
  type        = string
}

variable "vpc_id" {
  description = ""
  type        = string
}

variable "ingress_rules" {
  description = ""
  type        = map(any)
}

variable "egress_rules" {
  description = ""
  type        = map(any)
}