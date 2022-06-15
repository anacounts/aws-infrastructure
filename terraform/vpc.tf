# VPC

locals {
  vpc_name = "${var.app_name}-${var.app_env}-vpc"
}

## Create the VPC
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = local.vpc_name
  cidr = var.cidr

  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  azs             = var.availability_zones

  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = {
    Terraform   = "true"
    Environment = var.app_env
    Name        = local.vpc_name
  }
}
