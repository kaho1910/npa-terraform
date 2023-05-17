resource "aws_lb" "elb_webLB" {
    name = "web-elb"
    load_balancer_type = "application"
    internal = false
    subnets = [for i in range(var.subnet_count): aws_subnet.PublicNets[i]]
    security_groups = [aws_security_group.elb-sg.id]

    tags = merge(local.common_tags, { Name = "${var.cName}-webLB"})
}

resource "aws_lb_target_group" "elb-tg" {
  name = "elb-tg"
  port = 80
  protocol = "HTTP"
  vpc_id = module.vpc.vpc_id

  depends_on = [
    aws_lb.elb_webLB
  ]

  tags = merge(local.common_tags, { Name = "${var.cName}-tgp"})
}

resource "aws_lb_listener" "web_listener" {
  load_balancer_arn = aws_lb.elb_webLB.arn
  port = 80
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.tgp.arn
    
  }

  tags = merge(local.common_tags, { Name = "${var.cName}-web_listener"})
}
resource "aws_lb_target_group_attachment" "test" {
  count = var.instance_count
  target_group_arn = aws_lb_target_group.tgp.arn
  target_id = aws_instance.Servers[count.index].id
  port = 80
}
