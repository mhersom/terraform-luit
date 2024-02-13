#!/bin/bash

# Update the system packages
yum update -y

# Install Apache (httpd) web server
yum install -y httpd

# Start the Apache web server
systemctl start httpd

# Enable Apache to start on system boot
systemctl enable httpd
