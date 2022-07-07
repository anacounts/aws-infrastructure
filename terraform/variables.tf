# Application

## Environment specific variables that need to be set in terraform.tfvars
variable "app_env" {
  description = "The name of the environment being spun up, i.e. QA, Prod, Dev etc."
}
variable "app_domain" {
  description = "The domain hosting the application (e.g. \"anacounts.com\")"
}
variable "secrets_arn" {
  description = "The secrets for configuring the app (SECRET_KEY_BASE, DB_USER, DB_PASSWORD)"
}

## Defaults, can be overridden in terraform.tfvars if there is a need to
variable "app_name" {
  default     = "anacounts"
  description = "The application name"
}
variable "aws_region" {
  default     = "eu-west-3"
  description = "AWS region"
}

# Components

## ACM
variable "acm_us_east_1_cert" {
  description = "A certificate manually created in region us-east-1"
}

## VPC
variable "cidr" {
  default     = "10.0.0.0/16"
  description = "CIDR for the VPC"
}
variable "public_subnets" {
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
  description = "Public subnets for the VPC"
}
variable "private_subnets" {
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
  description = "Private subnets for the VPC"
}
variable "availability_zones" {
  default     = ["eu-west-3a", "eu-west-3b", "eu-west-3c"]
  description = "Availability zones for subnets"
}

## Security Groups
variable "ssh_allowed_cidr_blocks" {
  default     = ["0.0.0.0/0"]
  description = "List of CIDR blocks with SSH access to EC2 instances"
}

## RDS
variable "rds_instance_type" {
  default     = "db.t3.micro"
  description = "RDS instance type to use"
}
variable "rds_encrypt_at_rest" {
  default     = false
  description = "DB encryptiong settings, note t2.micro does not support encryption at rest"
}

## ECS
variable "max_instance_size" {
  default     = 1
  description = "Maximum number of instances in the cluster"
}
variable "min_instance_size" {
  default     = 0
  description = "Minimum number of instances in the cluster"
}
variable "desired_capacity" {
  default     = 1
  description = "Desired number of instances in the cluster"
}

variable "ecs_ami" {
  default = "ami-01bfbdfa7f51f5fe6" # eu-west-3
  # Full List: http://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-optimized_AMI.html
}
variable "ecs_instance_type" {
  default     = "t2.micro"
  description = "Instance type to use"
}
variable "key_pair_name" {
  default     = "anacounts_key_pair"
  description = "Key pair to use for ECS launch configuration, NOTE: it is assumed this key pair exists, it will not be created!"
}
