##################################################################################
# PROVIDERS
##################################################################################

provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  token      = var.token
  region     = var.region
}

##################################################################################
# DATA
##################################################################################

data "aws_ami" "aws-linux-2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-hvm*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


##################################################################################
# RESOURCES
##################################################################################

resource "aws_vpc" "testVPC" {
  cidr_block           = var.network_address_space
  enable_dns_hostnames = true

  tags = local.tag_vpc
}

resource "aws_internet_gateway" "testIgw" {
  vpc_id = aws_vpc.testVPC.id

  tags = local.tag_igw
}

resource "aws_route_table" "publicRoute" {
  vpc_id = aws_vpc.testVPC.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.testIgw.id
  }

  tags = local.tag_route
}

resource "aws_route_table_association" "rt-pubsub1" {
  subnet_id      = aws_subnet.Public1.id
  route_table_id = aws_route_table.publicRoute.id
}

##################################################################################
# OUTPUT
##################################################################################

output "aws_instance_public_ip" {
  value = aws_instance.testweb2.public_ip
}
