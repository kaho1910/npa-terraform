##################################################################################
# RESOURCES
##################################################################################

resource "aws_lb" "webLB" {
    name = var.name
    load_balancer_type = var.load_balancer_type
    internal = var.internal
    subnets = var.subnets
    security_groups = var.security_groups

    tags = merge(var.common_tags, { Name = "${var.addName}-web-loadbalancer"})
}

resource "aws_lb_target_group" "tgp" {
  name = var.target_group_name
  port = var.port
  protocol = var.protocol
  vpc_id = var.vpc_id

  depends_on = [
    aws_lb.webLB
  ]

  tags = merge(var.common_tags, { Name = "${var.addName}-tgp"})
}

resource "aws_lb_listener" "lbListener" {
  load_balancer_arn = aws_lb.webLB.arn
  port = var.port
  protocol = var.protocol

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.tgp.arn 
  }

  tags = merge(var.common_tags, { Name = "${var.addName}-listener"})
}

resource "aws_lb_target_group_attachment" "tgattach" {
  count = var.instance_count
  target_group_arn = aws_lb_target_group.tgp.arn
  target_id = var.target_id
  port = var.port
}
