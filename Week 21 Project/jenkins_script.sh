#!/bin/bash

#Download Java 8. Jenkins requires Java 8 or later.
sudo apt install -y default-jre

#Download Jenkins GPG key
sudo wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -

#Add Jenkins repository to APT sources list
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'

#Update package list
sudo apt update -y

#Install Jenkins
sudo apt install -y jenkins

#Start Jenkins service
sudo systemctl start jenkins