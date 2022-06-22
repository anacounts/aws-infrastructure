# ECS

locals {
  cluster_name         = "${var.app_name}-${var.app_env}"
  service_name         = "${var.app_name}-${var.app_env}-service"
  asg_name             = "${var.app_name}-${var.app_env}-asg"
  launch_config_prefix = "${var.app_name}-${var.app_env}-"
}

## Launch config
resource "aws_launch_configuration" "ecs_launch_configuration" {
  name_prefix          = local.launch_config_prefix
  image_id             = var.ecs_ami
  iam_instance_profile = aws_iam_instance_profile.ecs_agent.name
  instance_type        = var.ecs_instance_type

  lifecycle {
    create_before_destroy = true
  }

  security_groups             = [aws_security_group.app_sg.id, aws_security_group.ssh_sg.id]
  associate_public_ip_address = true
  key_name                    = var.key_pair_name

  user_data = <<EOF
#!/bin/bash

echo ECS_CLUSTER=${local.cluster_name} >> /etc/ecs/ecs.config
EOF
}

## Auto-scaling
resource "aws_autoscaling_group" "ecs_autoscaling_group" {
  name                 = local.asg_name
  max_size             = var.max_instance_size
  min_size             = var.min_instance_size
  desired_capacity     = var.desired_capacity
  vpc_zone_identifier  = module.vpc.public_subnets
  launch_configuration = aws_launch_configuration.ecs_launch_configuration.name

  health_check_grace_period = 300
  health_check_type         = "EC2"

  # populate the 'Name' field of the EC2 instance
  tag {
    key                 = "Name"
    value               = local.cluster_name
    propagate_at_launch = true
  }
}

## Cluster
resource "aws_ecs_cluster" "cluster" {
  name = local.cluster_name
}

## Task definition
data "template_file" "task_definition_template" {
  template = file("task_definition.json.tpl")
  vars = {
    NAME           = "${var.app_name}-${var.app_env}",
    REPOSITORY_URL = aws_ecr_repository.repository.repository_url
    ENVIRONMENT = jsonencode([
      {
        name : "SECRET_KEY_BASE",
        value : "${local.secret_key_base}"
      },
      {
        name : "DATABASE_URL",
        value : "postgres://${local.db_user}:${local.db_password}@${aws_db_instance.db.endpoint}/${aws_db_instance.db.db_name}"
      },
      {
        name : "HOST",
        value : "15.237.105.69"
      },
      {
        name : "FRONT_HOST",
        value : "https://${local.app_domain_name}/"
      }
    ])
  }
}

resource "aws_ecs_task_definition" "task" {
  family = local.cluster_name

  container_definitions = data.template_file.task_definition_template.rendered
}

## Service
resource "aws_ecs_service" "service" {
  name            = local.service_name
  cluster         = aws_ecs_cluster.cluster.arn
  task_definition = aws_ecs_task_definition.task.arn
  desired_count   = 1
}
