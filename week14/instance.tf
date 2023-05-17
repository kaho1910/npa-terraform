resource "aws_instance" "Server" {
  count = var.instance_count
  ami                    = data.aws_ami.aws-linux.id
  instance_type          = "t2.micro"
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.allow_ssh_web.id]
  subnet_id = module.vpc.public_subnets[count.index % length(module.vpc.public_subnets)]

  tags = merge(local.common_tags, { Name = "${var.cName}-Server${count.index}"})
}

