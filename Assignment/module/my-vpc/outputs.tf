output "vpc_id" {
  description = "Name (id) of the VPC"
  value       = aws_vpc.testVPC.id
}

output "public_subnets" {
  description = "List of public subnets"
  value = [for i in range(var.subnet_count - 1): aws_subnet.Subnet[i]]
}

output "private_subnets" {
  description = "List of public subnets"
  value = [aws_subnet.Subnet[var.subnet_count - 1]]
}