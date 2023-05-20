##################################################################################
# DATA
##################################################################################

data "aws_availability_zones" "available" {}

##################################################################################
# RESOURCES
##################################################################################
# NETWORKING #

resource "aws_vpc" "testVPC" {
  cidr_block           = var.network_address_space
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = merge(var.common_tags, { Name = "${var.addName}-VPC"})
}

resource "aws_subnet" "Subnet" {
  count = var.subnet_count
  vpc_id                  = aws_vpc.testVPC.id
  cidr_block              = cidrsubnet(var.network_address_space, 8, count.index)
  availability_zone       = slice(data.aws_availability_zones.available.names, count.index, count.index + 1)
  map_public_ip_on_launch = count.index != var.subnet_count

  tags = merge(var.common_tags, { Name = "${var.addName}-${count.index != var.subnet_count ? "publicsubnet" : "privatesubnet"}${count.index != var.subnet_count ? count.index : 1}"})
}

resource "aws_internet_gateway" "testIgw" {
  vpc_id = aws_vpc.testVPC.id

  tags = merge(var.common_tags, { Name = "${var.addName}-testIGW"})
}

resource "aws_route_table" "publicRoute" {
  vpc_id = aws_vpc.testVPC.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.testIgw.id
  }

  tags = merge(var.common_tags, { Name = "${var.addName}-publicRouteTable"})
}

resource "aws_nat_gateway" "privateNAT" {
  connectivity_type = "private"
  subnet_id         = aws_subnet.Subnet[var.subnet_count - 1].id
}

resource "aws_route_table" "privateRoute" {
  vpc_id = aws_vpc.testVPC.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.privateNAT.id
  }

  tags = merge(var.common_tags, { Name = "${var.addName}-privateRouteTable"})
}

resource "aws_route_table_association" "rt-pubsub" {
  count = var.subnet_count - 1
  subnet_id      = aws_subnet.Subnet[count.index].id
  route_table_id = aws_route_table.publicRoute.id
}

resource "aws_route_table_association" "rt-privsub" {
  subnet_id      = aws_subnet.Subnet[var.subnet_count - 1].id
  route_table_id = aws_route_table.privateRoute.id
}
