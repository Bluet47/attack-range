#!/bin/bash

# Update and install Docker
apt-get update
apt-get install -y docker.io

# Enable and start Docker
systemctl enable docker
systemctl start docker

# Pull and run Attack Range container
sudo docker pull splunk/attack_range
sudo docker run -it --name attack_range splunk/attack_range
