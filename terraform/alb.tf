locals {
  lb_name = "${var.app_name}-${var.app_env}-lb"
  tg_name = "${var.app_name}-${var.app_env}-target-group"
}

# Application load balancer
resource "aws_lb" "lb" {
  name               = local.lb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = module.vpc.public_subnets

  tags = {
    Environment = var.app_env
  }
}

## Target group for the load balancer
resource "aws_lb_target_group" "lb_target_group" {
  name     = local.tg_name
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id
}

## Associate the load balancer with the target group via a listner
resource "aws_lb_listener" "lb_listener" {
  load_balancer_arn = aws_lb.lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_target_group.arn
  }
}
