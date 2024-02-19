#//variable.tf file//#

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "pub_subnet1_cidr" {
  description = "CIDR block for Public Subnet1"
  type        = string
  default     = "10.0.1.0/24"
}

variable "pub_subnet2_cidr" {
  description = "CIDR block for Public Subnet2"
  type        = string
  default     = "10.0.2.0/24"
}

variable "priv_subnet1_cidr" {
  description = "CIDR block for Private Subnet1"
  type        = string
  default     = "10.0.3.0/24"
}

variable "priv_subnet2_cidr" {
  description = "CIDR block for Private Subnet2"
  type        = string
  default     = "10.0.4.0/24"
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.micro"
}

variable "min_instances" {
  description = "Minimum number of instances in Auto Scaling Group"
  default     = 2
}

variable "max_instances" {
  description = "Maximum number of instances in Auto Scaling Group"
  default     = 2
}

variable "linux_ami" {
  description = "ID of the Linux AMI to use"
  default     = "ami-0e731c8a588258d0d"
}

variable "ingress_ports" {
  description = "List of ingress ports"
  type        = list(number)
  default     = [80, 443]
}

variable "key_pair_name" {
  description = "Name of the key pair useds"
  type        = string
  default     = "ABC_KP" # Replace with your default key pair name
}