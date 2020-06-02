module "rds-db-api" {
  source  = "ispec-inc/mysql-utf8/rds"
  version = "1.3.1"

  db_name  = local.application_name_lower
  username = aws_ssm_parameter.main_rds_username.value
  password = aws_ssm_parameter.main_rds_password.value

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.database_subnets
}

resource "aws_ssm_parameter" "main_rds_password" {
  name        = "/${local.application_name}/main_rds/password"
  value       = "MODIFIED_PASSWORD"
  type        = "SecureString"
  description = "RDS password"

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "main_rds_username" {
  name        = "/${local.application_name}/main_rds/username"
  value       = "MODIFIED_USERNAME"
  type        = "SecureString"
  description = "RDS username"

  lifecycle {
    ignore_changes = [value]
  }
}