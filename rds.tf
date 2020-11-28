
resource "aws_db_subnet_group" "db" {
  subnet_ids = aws_subnet.private.*.id
}

resource "aws_db_instance" "rds" {
  name = "mydatabase"
  allocated_storage = 10
  engine = var.database_engine
  engine_version = var.database_engine_version
  instance_class = var.instance_class
  username = "someUserName"
  password = random_password.password.result
  skip_final_snapshot = true
  apply_immediately = true

  vpc_security_group_ids = [aws_security_group.rds.id]
  db_subnet_group_name = aws_db_subnet_group.db.name

  parameter_group_name = aws_db_parameter_group.db.name
}

resource "aws_db_parameter_group" "db" {
  name = "rds-pg"
  family = "mariadb10.5"

  parameter {
    name = "max_connections"
    value = var.max_connections
  }
}

resource "random_string" "username" {
  length = 24
  special = false
  number = false
}

resource "random_password" "password" {
  length = 32
  special = false
}
