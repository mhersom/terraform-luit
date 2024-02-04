/*
Name: Level Up in Tech - Week 21 Project 
Description: Introduction to Terraform
Contributors: Madison
*/

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1" # Specify your desired AWS region
}

# Create an EC2 instance
resource "aws_instance" "jenkins_instance" {
  ami           = "ami-0c7217cdde317cfec" # Specify the desired AMI ID
  instance_type = "t2.micro"              # Specify the desired instance type

  key_name = "ABC_KP" # Specify the key pair name for SSH access

  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]

  tags = {
    Name = "Jenkins"
  }

  user_data = file("jenkins_script.sh")

}

resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins_sg"
  description = "Jenkins Security group"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["3.89.182.31/32"] # Replace with your IP address
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
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

# Create an S3 bucket for Jenkins artifacts
resource "aws_s3_bucket" "jenkins_bucket" {
  bucket = "jenkins-bucket-mh-141414"
}

# Add ownership controls for the Jenkins S3 bucket
resource "aws_s3_bucket_ownership_controls" "jenkins_ownership_controls" {
  bucket = aws_s3_bucket.jenkins_bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "jenkins-acl" {
  bucket     = aws_s3_bucket.jenkins_bucket.id
  acl        = "private" # Set ACL to private to restrict public access
  depends_on = [aws_s3_bucket_ownership_controls.jenkins_ownership_controls]
}





