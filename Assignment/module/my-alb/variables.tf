variable "name" {
  type = string
  description = "Name of Load Balancer"
}

variable "load_balancer_type" {
  type = string
  description = "Type of Load Balancer"
}

variable "internal" {
  type = bool
  default = false
}

variable "target_id" {
  type = string
  description = "ID of Target"
}

variable "target_group_name" {
  type = string
  description = "Name of Target Group"
}

variable "subnets" {
    type = list(string)
    description = "List of Subnets"
}

variable "security_groups" {
    type = list(string)
    description = "List of Security Groups ID"
}

variable "vpc_id" {
    type = string
    description = "ID of VPC"
}

variable "instance_count"{
    type = number
    description = "Number of instances to create"
}

variable "port" {
  type = number
  description = "Port number for LB"
  default = "80"
}

variable "protocol" {
  type = string
  description = "Protocol for LB"
  default = "HTTP"
}

variable "common_tags" {
    type        = map(string)
    description = "Common name for tagging"
}

variable "addName" {
    type        = string
    description = "Common name for tagging"
}
