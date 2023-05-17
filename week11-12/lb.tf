resource "aws_lb_target_group" "elb-tg" {
  name        = "elb-tg"
  target_type = "instance"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.testVPC.id

  depends_on = [
    aws_lb.elb_webLB
  ]
}

resource "aws_lb" "elb_webLB" {
  name               = "elb-webLB"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg2.id]
  subnets            = [aws_subnet.Public1.id, aws_subnet.Public2.id]
}

resource "aws_lb_target_group_attachment" "test" {
  target_group_arn = aws_lb_target_group.elb-tg.arn
  target_id        = aws_instance.testweb2.id
  port             = 80
}

resource "aws_lb_listener" "web_listener" {
  load_balancer_arn = aws_lb.elb_webLB.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.elb-tg.arn
  }
}