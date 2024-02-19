# AWS region variable
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

# CIDR block for the VPC variable
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "172.31.0.0/16"
}

# CIDR block for Subnet1 variable
variable "subnet1_cidr" {
  description = "CIDR block for Subnet1"
  type        = string
  default     = "172.31.1.0/24"
}

# CIDR block for Subnet2 variable
variable "subnet2_cidr" {
  description = "CIDR block for Subnet2"
  type        = string
  default     = "172.31.2.0/24"
}

# EC2 instance type variable
variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.micro"
}

# Minimum number of instances in Auto Scaling Group variable
variable "min_instances" {
  description = "Minimum number of instances in Auto Scaling Group"
  default     = 2
}

# Maximum number of instances in Auto Scaling Group variable
variable "max_instances" {
  description = "Maximum number of instances in Auto Scaling Group"
  default     = 5
}

# ID of the Linux AMI to use variable
variable "linux_ami" {
  description = "ID of the Linux AMI to use"
  default     = "ami-0e731c8a588258d0d"
}

# List of ingress ports variable
variable "ingress_ports" {
  description = "List of ingress ports"
  type        = list(number)
  default     = [80, 443]
}

# Key variable
variable "key" {
  default = "ABC_KP"
  type    = string
}
