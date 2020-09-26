#   Project
##############

region       = "eu-west-1"
project_name = "cloud1"

#   Networking
#################

vpc_cidr           = "10.0.0.0/16"
availability_zones = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]

#   Database
###############

db_engine            = "mysql"
db_engine_version    = "8.0.17"
parameter_group_name = "default.mysql8.0"
db_instance_class    = "db.t2.micro"
db_storage           = 20
db_storage_type      = "gp2"

# should be secret
rds_identifier = "wordpress"
rds_db         = "wordpress"
rds_user       = "admin"
rds_password   = "12341234"