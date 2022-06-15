# IAM

locals {
  instance_role_name    = "${var.app_name}-${var.app_env}-ecs-instance-role"
  instance_profile_name = "${var.app_name}-${var.app_env}-ecs-instance-profile"
  service_role_name     = "${var.app_name}-${var.app_env}-ecs-service-role"
}

data "aws_iam_policy_document" "ecs_agent" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

## ECS EC2 instance role
resource "aws_iam_role" "ecs_agent" {
  name               = local.instance_role_name
  assume_role_policy = data.aws_iam_policy_document.ecs_agent.json
}

resource "aws_iam_role_policy_attachment" "ecs_agent" {
  role       = aws_iam_role.ecs_agent.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ecs_agent" {
  name = local.instance_profile_name
  role = aws_iam_role.ecs_agent.name
}
