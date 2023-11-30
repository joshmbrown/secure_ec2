# configured aws provider with proper credentials
provider "aws" {
  region    = "us-east-1"
  profile   = "default"
}


# create default vpc if one does not exit
resource "aws_default_vpc" "default_vpc" {

  tags    = {
    Name  = "default vpc"
  }
}


# use data source to get all avalablility zones in region
data "aws_availability_zones" "available_zones" {}


# create default subnet if one does not exit
resource "aws_default_subnet" "default_az1" {
  availability_zone = data.aws_availability_zones.available_zones.names[0]

  tags   = {
    Name = "default subnet"
  }
}


# create security group for the ec2 instance
resource "aws_security_group" "ec2_security_group" {
  name        = "ec2 security group"
  description = "allow access on port 22"
  vpc_id      = aws_default_vpc.default_vpc.id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags   = {
    Name = "ec2 security group"
  }
}


resource "aws_instance" "sift_instance" {
  ami           = "ami-09106f5dc4f9a4496"
  instance_type = "t2.micro"
  key_name      = "is565-creation"
  
  vpc_security_group_ids = [aws_security_group.ec2_security_group.id]

  tags = {
    Name = "SIFT-Instance"
  }
}

