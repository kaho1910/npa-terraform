##################################################################################
# VARIABLE
##################################################################################

variable "aws_access_key" {
    type = string
    sensitive = true
}

variable "aws_secret_key" {
    type = string
    sensitive = true
}

variable "token" {
    type = string
    sensitive = false
}

variable "keynam"{
    default = "vockey"
}

variable "region" {
    default = "us-east-1"
}

variable "network_address_space" {
    default = "10.0.0.0/16"
}