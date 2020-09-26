##########################
#   AUTO-SCALING GROUP   #
##########################

#   ami
##########

data "aws_ami" "amazon-linux-2" {
  depends_on = [aws_db_instance.mysql_wordpress]

  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

#   bootstrap template
#########################

data "template_file" "wordpress_init" {
  template = file("wordpress_bootstrap.sh")

  vars = {
    rds_address  = aws_db_instance.mysql_wordpress.address,
    rds_db       = var.rds_db
    rds_user     = var.rds_user,
    rds_password = var.rds_password
  }
}

#   Launch configuration
###########################

resource "aws_launch_configuration" "wordpress_configuration" {
  depends_on = [
    aws_internet_gateway.cloud1_igw,
    aws_db_instance.mysql_wordpress
  ]

  image_id                    = data.aws_ami.amazon-linux-2.id
  associate_public_ip_address = true
  instance_type               = var.server_instance_class
  key_name                    = var.key_name
  security_groups             = [aws_security_group.cloud1_wp_sg.id]
  user_data                   = data.template_file.wordpress_init.rendered

  lifecycle {
    create_before_destroy = true
  }
}

#   Auto-scaling group
#########################

resource "aws_autoscaling_group" "wordpress_asg" {
  depends_on = [aws_launch_configuration.wordpress_configuration]

  launch_configuration = aws_launch_configuration.wordpress_configuration.id
  vpc_zone_identifier  = aws_subnet.cloud1_public_subnet.*.id

  min_size          = var.asg_min_conf
  max_size          = var.asg_max_conf
  load_balancers    = [aws_elb.wordpress_elb.name]
  health_check_type = "ELB"

  tag {
    key                 = "Wordpress auto-scaling group"
    value               = "wordpress-asg"
    propagate_at_launch = true
  }
}