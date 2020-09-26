###########
#   RDS   #
###########

resource "aws_db_subnet_group" "db_subnet_group" {
  depends_on = [aws_subnet.cloud1_private_subnet]

  name       = "db_subnet_group"
  subnet_ids = aws_subnet.cloud1_private_subnet.*.id
}

resource "aws_db_instance" "mysql_wordpress" {
  depends_on = [aws_subnet.cloud1_private_subnet]

  allocated_storage      = var.db_storage
  identifier             = var.rds_identifier
  storage_type           = var.db_storage_type
  engine                 = var.db_engine
  engine_version         = var.db_engine_version
  instance_class         = var.db_instance_class
  name                   = var.rds_db
  username               = var.rds_user
  password               = var.rds_password
  parameter_group_name   = var.parameter_group_name
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.cloud1_mysql_sg.id]

  tags = {
    "Name"    = "${var.project_name}-db"
    "Project" = var.project_name
  }
}