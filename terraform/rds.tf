# RDS

locals {
  identifier = "${var.app_name}-${var.app_env}-db"
  # dashes are not valid database names so replace dashes with underscores
  instance_name     = "${replace(var.app_name, "-", "_")}_${var.app_env}"
  subnet_group_name = "${var.app_name}-${var.app_env}-db-subnet"
}

resource "aws_db_subnet_group" "db_sn" {
  name       = local.subnet_group_name
  subnet_ids = module.vpc.private_subnets
}

resource "aws_db_instance" "db" {
  # database access
  identifier = local.identifier
  db_name    = local.instance_name
  username   = local.db_user
  password   = local.db_password
  port       = 5432

  # instance
  engine         = "postgres"
  engine_version = "14.2"
  instance_class = var.rds_instance_type

  # storage
  allocated_storage     = 20
  max_allocated_storage = 1000
  storage_type          = "gp2"
  storage_encrypted     = var.rds_encrypt_at_rest

  # backup, snapshots, high availability
  backup_retention_period   = 7
  final_snapshot_identifier = "${local.identifier}-final-snapshot"
  multi_az                  = false

  # subnet, vpc, accessibility
  db_subnet_group_name = aws_db_subnet_group.db_sn.name

  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  publicly_accessible = false

  # tags
  tags = {
    Name = local.identifier
  }
}
