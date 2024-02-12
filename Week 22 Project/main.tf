/*
  Name: Level Up in Tech - Week 22 Project
  Description: Getting Comfortable with Terraform
  Contributors: Madison
*/

# Configure the AWS Provider
provider "aws" {
  region = var.aws_region
}

# Get information about the default VPC
data "aws_vpcs" "default" {
  filter {
    name   = "isDefault"
    values = ["true"]
  }
}

# Create subnets in the VPC
resource "aws_subnet" "subnet-public-1" {
  vpc_id                  = data.aws_vpcs.default.ids[0]
  cidr_block              = "172.31.1.0/24"
  map_public_ip_on_launch = true # it makes this a public subnet
  availability_zone       = "us-east-1a"
  tags = {
    Name = "subnet-public-1"
  }
}

resource "aws_subnet" "subnet-public-2" {
  vpc_id                  = data.aws_vpcs.default.ids[0]
  cidr_block              = "172.31.2.0/24"
  map_public_ip_on_launch = true # it makes this a public subnet
  availability_zone       = "us-east-1b"
  tags = {
    Name = "subnet-public-2"
  }
}

# Security Group
resource "aws_security_group" "web_sg" {
  name        = "web_sg"
  description = "Security group for web instances"
  vpc_id      = data.aws_vpcs.default.ids[0]

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Launch Configuration
resource "aws_launch_configuration" "web_lc" {
  image_id      = var.linux_ami
  instance_type = var.instance_type

  user_data = <<-EOF
              #!/bin/bash
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              EOF

  security_groups = [aws_security_group.web_sg.id]
}

# Auto Scaling Group
resource "aws_autoscaling_group" "web_asg" {
  desired_capacity    = var.min_instances
  max_size            = var.max_instances
  min_size            = var.min_instances
  vpc_zone_identifier = [aws_subnet.subnet-public-1.id, aws_subnet.subnet-public-2.id]

  launch_configuration = aws_launch_configuration.web_lc.id
}

# Create an S3 bucket for Apache artifacts
resource "aws_s3_bucket" "apache_bucket" {
  bucket = "apache-bucket-mh-141414"
  acl    = "private"
}