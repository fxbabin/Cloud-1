########################
#   WORDPRESS-EC2-SG   #
########################

resource "aws_security_group" "cloud1_wp_sg" {

  depends_on = [
    aws_vpc.cloud1_vpc,
    aws_subnet.cloud1_public_subnet
  ]

  name        = "wordpress-sg"
  description = "HTTP, SSH"
  vpc_id      = aws_vpc.cloud1_vpc.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "output from wordpress server"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

##############
#   RDS-SG   #
##############

resource "aws_security_group" "cloud1_mysql_sg" {

  depends_on = [
    aws_vpc.cloud1_vpc,
    aws_subnet.cloud1_private_subnet
  ]

  name        = "mysql-sg"
  description = "MySQL access for wordpress server"
  vpc_id      = aws_vpc.cloud1_vpc.id

  ingress {
    description     = "MySQL input"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.cloud1_wp_sg.id]
  }

  egress {
    description = "MySQL output"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

##############
#   ELB-SG   #
##############

resource "aws_security_group" "elb_sg" {
  vpc_id = aws_vpc.cloud1_vpc.id
  name   = "cloud1-elb"

  ingress {
    description = "Load balancer input"
    from_port   = 80
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Load balancer output"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}