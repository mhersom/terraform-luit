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
  cidr_block              = var.subnet1_cidr
  map_public_ip_on_launch = true # it makes this a public subnet
  availability_zone       = "us-east-1a"
  tags = {
    Name = "subnet-public-1"
  }
}

resource "aws_subnet" "subnet-public-2" {
  vpc_id                  = data.aws_vpcs.default.ids[0]
  cidr_block              = var.subnet2_cidr
  map_public_ip_on_launch = true # it makes this a public subnet
  availability_zone       = "us-east-1b"
  tags = {
    Name = "subnet-public-2"
  }
}

# Create Security Group
resource "aws_security_group" "web_sg" {
  name        = "web_sg"
  description = "Security group for web instances"
  vpc_id      = data.aws_vpcs.default.ids[0]

  # Inbound Http, Https, and SSH
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

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound Internet Access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create Launch Template
resource "aws_launch_template" "lt-asg" {
  name                   = "lt-asg"
  image_id               = var.linux_ami
  instance_type          = var.instance_type
  key_name               = var.key
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  user_data = filebase64("${path.module}/apache_install.sh")
}

# Create Auto Scaling Group
resource "aws_autoscaling_group" "web_asg" {
  desired_capacity    = var.min_instances
  max_size            = var.max_instances
  min_size            = var.min_instances
  vpc_zone_identifier = [aws_subnet.subnet-public-1.id, aws_subnet.subnet-public-2.id]

  # Attach Launch Template to Auto Scaling Group
  launch_template {
    id      = aws_launch_template.lt-asg.id
    version = "$Latest" # or specify the version you want
  }
}

# Create an S3 bucket for Apache artifacts
resource "aws_s3_bucket" "apache_bucket" {
  bucket = "apache-bucket-mh-123123123"
  acl    = "private"
}
