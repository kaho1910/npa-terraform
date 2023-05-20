
# import local module
module "my_alb" {
    source = "./module/my-alb"

    name = "web-elb"
    load_balancer_type = "application"
    target_id = aws_instance.Servers[count.index].id
    target_group_name = "tf-target-group"
    subnets = [for i in range(var.subnet_count - 1): module.my_vpc.public_subnets[i]]
    security_groups = [aws_security_group.elb-sg.id]
    vpc_id = module.my_vpc.vpc_id
    instance_count = var.instance_count

    addName = local.cName
    common_tags = local.common_tags
}
