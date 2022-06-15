# ARNs for secrets stored in AWS Secrets Manager

data "aws_secretsmanager_secret_version" "secret_key_base" {
  secret_id = var.secret_key_base_arn
}
data "aws_secretsmanager_secret_version" "db_user" {
  secret_id = var.db_user_arn
}
data "aws_secretsmanager_secret_version" "db_password" {
  secret_id = var.db_password_arn
}

## Create local variables from secret values

locals {
  secret_key_base = jsondecode(data.aws_secretsmanager_secret_version.secret_key_base.secret_string)["SECRET_KEY_BASE"]
  db_user         = jsondecode(data.aws_secretsmanager_secret_version.db_user.secret_string)["DB_USER"]
  db_password     = jsondecode(data.aws_secretsmanager_secret_version.db_password.secret_string)["DB_PASSWORD"]
}
