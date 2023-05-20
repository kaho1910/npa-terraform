variable "network_address_space" {
  type        = string
  description = "Base CIDR Block for VPC"
}

variable "subnet_count" {
    type = number
    description = "Number of subnets to create"
}

variable "enable_dns_hostnames" {
    type        = bool
    description = "Enable DNS hostnames in VPC"
}

variable "common_tags" {
    type        = map(string)
    description = "Common name for tagging"
}

variable "addName" {
    type        = string
    description = "Common name for tagging"
}
