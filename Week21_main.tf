terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Create an EC2 instance
resource "aws_instance" "jenkins_instance" {
  ami           = "ami-0c7217cdde317cfec" # Specify the desired AMI ID
  instance_type = "t2.micro"              # Specify the desired instance type

  key_name = "[INSERT KEY PAIR NAME]" # Specify the key pair name for SSH access

  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]

  tags = {
    Name = "Jenkins"
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install -y default-jre
              wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
              sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
              sudo apt update -y
              sudo apt install -y jenkins
              sudo systemctl enable jenkins
              sudo systemctl start jenkins
              EOF

}

# Create a security group for Jenkins
resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins_sg"
  description = "Jenkins Security group"

  # Allow SSH access for administration (replace with your IP address)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["50.4.49.47/32"] # Replace with your IP address
  }

  # Allow HTTP access to Jenkins web interface on port 8080
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow access from any IP
  }

  # Allow HTTPS access to Jenkins web interface on ports 443 and 433
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow access from any IP
  }

  # Allow all outbound traffic from the Jenkins instance
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # Allow all protocols
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
