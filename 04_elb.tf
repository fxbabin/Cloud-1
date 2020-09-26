#####################
#   LOAD BALANCER   #
#####################

resource "aws_elb" "wordpress_elb" {
  name                      = "wordpress-elb"
  subnets                   = aws_subnet.cloud1_public_subnet.*.id
  security_groups           = [aws_security_group.elb_sg.id]
  cross_zone_load_balancing = true

  health_check {
    target              = "HTTP:80/"
    interval            = 30
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  listener {
    lb_port           = 80
    lb_protocol       = "http"
    instance_port     = 80
    instance_protocol = "http"
  }
}

output "elb_dns_name" {
  value       = aws_elb.wordpress_elb.dns_name
  description = "The domain name of the load balancer"
}