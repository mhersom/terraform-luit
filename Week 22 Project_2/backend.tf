# Configure the backend for storing Terraform state in the Apache S3 bucket
terraform {
  backend "s3" {
    bucket  = "apache-bucket-mh-123123123"
    key     = "terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}