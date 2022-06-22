# SECURITY GROUPS

locals {
  app_sg_name = "${var.app_name}-${var.app_env}-application-sg"
  ssh_sg_name = "${var.app_name}-${var.app_env}-ssh-sg"
  rds_sg_name = "${var.app_name}-${var.app_env}-rds-sg"
}

## Create a security group for the ec2 instances
resource "aws_security_group" "app_sg" {
  name        = local.app_sg_name
  description = "HTTP access from everywhere"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = local.app_sg_name
  }
}

## Create a security group to enable ssh access
resource "aws_security_group" "ssh_sg" {
  name        = local.ssh_sg_name
  description = "SSH access from configured IPs"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ssh_allowed_cidr_blocks
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = local.ssh_sg_name
  }
}

## Create a security group for the RDS instance
resource "aws_security_group" "rds_sg" {
  name        = local.rds_sg_name
  description = "RDS security group"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.app_sg.id]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name = local.rds_sg_name
  }
}
