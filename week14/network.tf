data "aws_availability_zones" "available" {}

resource "aws_vpc" "testVPC" {
  cidr_block           = var.network_address_space
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = merge(local.common_tags, { Name = "${var.cName}-VPC"})
}

resource "aws_internet_gateway" "testIgw" {
  vpc_id = aws_vpc.testVPC.id

  tags = merge(local.common_tags, { Name = "${var.cName}-IGW"})
}

resource "aws_subnet" "PublicNets" {
  count = var.subnet_count
  cidr_block              = cidrsubnet(var.network_address_space, 8, count.index)
  vpc_id                  = aws_vpc.testVPC.id
  map_public_ip_on_launch = var.map_public_ip
  availability_zone       = data.aws_availability_zones.available.names[count.index]

  tags = merge(local.common_tags, { Name = "${var.cName}-subnet${count.index}"})
}

resource "aws_route_table" "publicRoute" {
  vpc_id = aws_vpc.testVPC.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.testIgw.id
  }

  tags = merge(local.common_tags, { Name = "${var.cName}-PublicRouteTable"})
}

resource "aws_route_table_association" "rt-pubsub1" {
  count = var.subnet_count
  subnet_id      = aws_subnet.PublicNets[count.index].id
  route_table_id = aws_route_table.publicRoute.id
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


resource "aws_security_group" "sg1" {
  name   = "allow-ssh"
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
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, { Name = "${var.cName}-serverSG"})
}