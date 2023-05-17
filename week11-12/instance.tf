resource "aws_instance" "Server2" {
  count                  = var.instance_count
  ami                    = data.aws_ami.aws-linux-2.id
  instance_type          = "t2.micro"
  key_name               = "vockey"
  vpc_security_group_ids = [aws_security_group.sg2.id]
  subnet_id              = aws_subnet[var.count]
  tags = merge(local.common_tags, { Name = "${var.cName}-Server${count.index}"})
}
