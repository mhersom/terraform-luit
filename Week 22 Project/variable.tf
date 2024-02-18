variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "172.31.0.0/16"
}

variable "subnet1_cidr" {
  description = "CIDR block for Subnet1"
  type        = string
  default     = "172.31.1.0/24"
}

variable "subnet2_cidr" {
  description = "CIDR block for Subnet2"
  type        = string
  default     = "172.31.2.0/24"
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
  default     = 5
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

variable "key" {
  default = "ABC_KP"
  type    = string
}
