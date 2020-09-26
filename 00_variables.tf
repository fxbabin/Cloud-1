variable "region" {}
variable "project_name" {}

variable "vpc_cidr" {}
variable "availability_zones" {}

variable "db_engine" {}
variable "db_engine_version" {}
variable "parameter_group_name" {}
variable "db_instance_class" {}
variable "db_storage" {}
variable "db_storage_type" {}

variable "rds_identifier" {}
variable "rds_db" {}
variable "rds_user" {}
variable "rds_password" {}

variable "server_instance_class" {}
variable "key_name" {}
variable "asg_min_conf" {}
variable "asg_max_conf" {}