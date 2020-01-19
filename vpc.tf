provider "aws" {
  version = "~> 2.0"
  region  = "eu-west-3"
}

#########
#  VPC  #
#########
resource "aws_vpc" "cloud1" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "cloud1-vpc"
  }
}

#############
#  SUBNETS  #
#############

resource "aws_subnet" "pub-1" {
  vpc_id     = "${aws_vpc.cloud1.id}"
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "pub-1"
  }
}

resource "aws_subnet" "priv-1" {
  vpc_id     = "${aws_vpc.cloud1.id}"
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "priv-1"
  }
}

resource "aws_subnet" "priv-2" {
  vpc_id     = "${aws_vpc.cloud1.id}"
  cidr_block = "10.0.3.0/24"

  tags = {
    Name = "priv-2"
  }
}