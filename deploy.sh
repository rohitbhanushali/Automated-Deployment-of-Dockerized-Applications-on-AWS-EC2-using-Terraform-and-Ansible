#!/bin/bash
# Comprehensive deployment script for Dockerized Applications on AWS EC2

# Exit on error
set -e

# Default values
PROJECT_NAME=${PROJECT_NAME:-"docker-app"}
ENVIRONMENT=${ENVIRONMENT:-"development"}
REGION=${REGION:-"ap-south-1"}
SSH_KEY_PATH=${SSH_KEY_PATH:-"~/.ssh/id_rsa.pub"}

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Print with color
print_color() {
  local color=$1
  local message=$2
  echo -e "${color}${message}${NC}"
}

# Print section header
print_header() {
  local message=$1
  echo ""
  print_color "${YELLOW}" "===== $message ====="
  echo ""
}

# Check if required tools are installed
check_requirements() {
  print_header "Checking Requirements"
  
  # Check AWS CLI
  if ! command -v aws &> /dev/null; then
    print_color "${RED}" "AWS CLI is not installed. Please install it first."
    exit 1
  fi
  
  # Check Terraform
  if ! command -v terraform &> /dev/null; then
    print_color "${RED}" "Terraform is not installed. Please install it first."
    exit 1
  fi
  
  # Check Ansible
  if ! command -v ansible &> /dev/null; then
    print_color "${RED}" "Ansible is not installed. Please install it first."
    exit 1
  fi
  
  # Check Python
  if ! command -v python3 &> /dev/null; then
    print_color "${RED}" "Python 3 is not installed. Please install it first."
    exit 1
  fi
  
  # Check SSH key
  if [ ! -f "$SSH_KEY_PATH" ]; then
    print_color "${RED}" "SSH key not found at $SSH_KEY_PATH. Please create it first."
    exit 1
  fi
  
  print_color "${GREEN}" "All requirements satisfied."
}

# Deploy infrastructure with Terraform
deploy_infrastructure() {
  print_header "Deploying Infrastructure with Terraform"
  
  # Navigate to Terraform directory
  cd terraform
  
  # Initialize Terraform
  print_color "${YELLOW}" "Initializing Terraform..."
  terraform init
  
  # Create terraform.tfvars file
  print_color "${YELLOW}" "Creating terraform.tfvars file..."
  cat > terraform.tfvars << EOF
region = "$REGION"
environment = "$ENVIRONMENT"
project_name = "$PROJECT_NAME"
public_key_path = "$SSH_KEY_PATH"
EOF
  
  # Plan Terraform
  print_color "${YELLOW}" "Planning Terraform deployment..."
  terraform plan -out=tfplan
  
  # Apply Terraform
  print_color "${YELLOW}" "Applying Terraform configuration..."
  terraform apply -auto-approve tfplan
  
  # Get outputs
  print_color "${YELLOW}" "Getting Terraform outputs..."
  INSTANCE_IP=$(terraform output -raw public_ip)
  
  # Return to root directory
  cd ..
  
  print_color "${GREEN}" "Infrastructure deployment completed."
  print_color "${GREEN}" "EC2 Instance IP: $INSTANCE_IP"
}

# Deploy application with Ansible
deploy_application() {
  print_header "Deploying Application with Ansible"
  
  # Navigate to Ansible directory
  cd ansible
  
  # Set environment variables for dynamic inventory
  export PROJECT_NAME=$PROJECT_NAME
  export ENVIRONMENT=$ENVIRONMENT
  
  # Make the inventory script executable
  chmod +x ec2_inventory.py
  
  # Install required Python packages
  print_color "${YELLOW}" "Installing required Python packages..."
  pip install -r requirements.txt
  
  # Run Ansible playbook
  print_color "${YELLOW}" "Running Ansible playbook..."
  ansible-playbook -i ec2_inventory.py playbook.yml -v
  
  # Return to root directory
  cd ..
  
  print_color "${GREEN}" "Application deployment completed."
}

# Main deployment process
main() {
  print_color "${GREEN}" "Starting deployment process for $PROJECT_NAME in $ENVIRONMENT environment..."
  
  # Check requirements
  check_requirements
  
  # Deploy infrastructure
  deploy_infrastructure
  
  # Wait for instance to be ready
  print_header "Waiting for EC2 instance to be ready"
  print_color "${YELLOW}" "Waiting 60 seconds for the instance to initialize..."
  sleep 60
  
  # Deploy application
  deploy_application
  
  print_color "${GREEN}" "Deployment completed successfully!"
  print_color "${GREEN}" "You can access your application at http://$INSTANCE_IP"
}

# Run main function
main 