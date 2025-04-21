#!/bin/bash
# Script to run the Ansible playbook with dynamic inventory

# Set environment variables
export PROJECT_NAME=${PROJECT_NAME:-"docker-app"}
export ENVIRONMENT=${ENVIRONMENT:-"development"}

# Make the inventory script executable
chmod +x ec2_inventory.py

# Install required Python packages
pip install -r requirements.txt

# Run the Ansible playbook with dynamic inventory
ansible-playbook -i ec2_inventory.py playbook.yml "$@" 