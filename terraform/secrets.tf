# ARNs for secrets stored in AWS Secrets Manager

data "aws_secretsmanager_secret_version" "secrets" {
  secret_id = var.secrets_arn
}

## Create local variables from secret values

locals {
  secret_key_base = jsondecode(data.aws_secretsmanager_secret_version.secrets.secret_string)["SECRET_KEY_BASE"]
  db_user         = jsondecode(data.aws_secretsmanager_secret_version.secrets.secret_string)["DB_USER"]
  db_password     = jsondecode(data.aws_secretsmanager_secret_version.secrets.secret_string)["DB_PASSWORD"]
}
