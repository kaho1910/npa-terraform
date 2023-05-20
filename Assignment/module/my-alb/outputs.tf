output "load_balancer_arn" {
  description = "ARN of the Load Balancer"
  value       = aws_lb.webLB.arn
}

output "lb_target_group_arn" {
  description = "ARN of the Load Balancer Target Group"
  value       = aws_lb_target_group.tgp.arn
}

output "dns_name" {
  value = aws_lb.webLB.dns_name
}