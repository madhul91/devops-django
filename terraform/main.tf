provider "aws" {
  region = var.region
}


data "aws_vpc" "default" {
  default = true
}


data "aws_subnets" "public_subnets" {
  filter {
    name   = "map-public-ip-on-launch"
    values = ["true"]
  }

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}


resource "aws_security_group" "devops_sg" {
  name_prefix = "chat-app-sg-"
  vpc_id = data.aws_vpc.default.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "App Port"
    from_port   = 8056
    to_port     = 8056
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
   ingress {
    description = "App Port"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_instance" "devops_ec2" {
  ami           = var.ami
  instance_type = "t3.small"
  key_name      = var.key_name

  # subnet_id              = data.aws_subnets.public_subnets[0]
  subnet_id = data.aws_subnets.public_subnets.ids[0]
  vpc_security_group_ids = [aws_security_group.devops_sg.id]

  associate_public_ip_address = true


  root_block_device {
    volume_size = 10
    volume_type = "gp3"
  }

   

  tags = {
    Name = "DevOps-Docker-Server"
  }
}
##
