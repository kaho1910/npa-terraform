locals {
    tag_vpc = {
        Name = "itKMITL-VPC"
    }
    tag_subnet_1 = {
        Name = "itKMITL-PublicSubnet1"
    }
    tag_subnet_2 = {
        Name = "itKMITL-PublicSubnet2"
    }
    tag_igw = {
        Name = "itKMITL-IGW"
    }
    tag_route = {
        Name = "itKMITL-publicRoute"
    }
    tag_server_1 = {
        Name    = "itKMITL-Server1"
        itclass = "npa23"
        itgroup = "year3"
    }
    tag_server_2 = {
        Name    = "itKMITL-Server2"
        itclass = "npa23"
        itgroup = "year3"
  }
}