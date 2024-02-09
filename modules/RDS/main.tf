resource "aws_db_instance" "db_instance_stage" {
  engine                 = "postgres"
  identifier             = "tstdbinstance"
  db_name                = "postgresdb"
  instance_class         = var.db-instance-class # Update with your desired instance type
  allocated_storage      = var.storage           # Update with your desired storage size (in GB)
  multi_az               = true                  # Enable multi-AZ deployment
  storage_encrypted      = true
  db_subnet_group_name   = aws_db_subnet_group.db-subnet-group-stage.id
  vpc_security_group_ids = [var.rds_sg_id]
  username               = "test"
  password               = random_password.db_password.result

  # Use the latest available version of PostgreSQL
  engine_version = var.db_engine_version
  tags = {
    Name = "db_instance_${var.env}"
  }
}

resource "aws_db_subnet_group" "db-subnet-group-stage" {
  name       = "db-subnet-group-tst"
  subnet_ids = var.private_subnet_output
  tags = {
    Name = "db-subnet-group-${var.env}"

  }
}

resource "random_password" "db_password" {
  length           = 12
  special          = true
  min_special      = 2
  override_special = "!#$%^&*()-_=+[]{}<>:?"
}

resource "aws_secretsmanager_secret" "db-password" {
  name = "dbpwd-${var.env}"
}

resource "aws_secretsmanager_secret_version" "db-password-value" {
  secret_id     = aws_secretsmanager_secret.db-password.id
  secret_string = random_password.db_password.result
}
