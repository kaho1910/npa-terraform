##################################################################################
# PROVIDERS
##################################################################################
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.0.1"
    }
}
}

provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  token      = var.session_token
  region     = var.region
}