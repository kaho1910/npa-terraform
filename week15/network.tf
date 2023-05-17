##################################################################################
# DATA
##################################################################################

data "aws_availability_zones" "available" {}

##################################################################################
# RESOURCES
##################################################################################
# NETWORKING #


# import Remote Module
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "4.0.1"
  name = "testVPC"
  cidr = "10.0.0.0/16"

  azs             = slice(data.aws_availability_zones.available.names, 0, var.subnet_count)
  # private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = [for i in range(var.subnet_count): cidrsubnet(var.network_address_space, 8, i)]

  enable_nat_gateway = false
  enable_vpn_gateway = false
  enable_dns_hostnames =  var.enable_dns_hostnames

  tags = merge(local.common_tags, { Name = "${var.cName}-VPC"})
}

# SECURITY GROUPS #
# ALB Security Group
resource "aws_security_group" "elb-sg" {
  name   = "elb_sg"
  vpc_id = module.vpc.vpc_id

  #Allow HTTP from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #allow all outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, { Name = "${var.cName}-elbSG"})

}


resource "aws_security_group" "allow_ssh_web" {
  name   = "npaWk11_demo"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.network_address_space]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, { Name = "${var.cName}-serverSG"})
}