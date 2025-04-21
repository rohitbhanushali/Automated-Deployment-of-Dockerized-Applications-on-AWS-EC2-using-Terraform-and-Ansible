#!/bin/bash

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
NC='\033[0m'

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

# Function to rollback Docker Compose deployment
rollback_docker_compose() {
    print_header "Rolling back Docker Compose deployment"
    
    # Navigate to app directory
    cd /home/ec2-user/app
    
    # Stop all containers
    print_color "${YELLOW}" "Stopping all containers..."
    docker-compose down
    
    # Remove volumes
    print_color "${YELLOW}" "Removing volumes..."
    docker volume prune -f
    
    print_color "${GREEN}" "Docker Compose rollback completed"
}

# Function to rollback infrastructure
rollback_infrastructure() {
    print_header "Rolling back infrastructure"
    
    # Navigate to Terraform directory
    cd terraform
    
    # Destroy infrastructure
    print_color "${YELLOW}" "Destroying infrastructure..."
    terraform destroy -auto-approve
    
    print_color "${GREEN}" "Infrastructure rollback completed"
}

# Function to clean up AWS resources
cleanup_aws_resources() {
    print_header "Cleaning up AWS resources"
    
    # Delete SNS topic
    print_color "${YELLOW}" "Deleting SNS topic..."
    aws sns delete-topic --topic-arn "arn:aws:sns:${REGION}:$(aws sts get-caller-identity --query Account --output text):${PROJECT_NAME}-${ENVIRONMENT}-alerts"
    
    # Delete CloudWatch alarms
    print_color "${YELLOW}" "Deleting CloudWatch alarms..."
    aws cloudwatch delete-alarms --alarm-names "${PROJECT_NAME}-${ENVIRONMENT}-cpu-utilization" "${PROJECT_NAME}-${ENVIRONMENT}-memory-utilization" "${PROJECT_NAME}-${ENVIRONMENT}-disk-utilization"
    
    print_color "${GREEN}" "AWS resources cleanup completed"
}

# Main rollback process
main() {
    print_color "${RED}" "Starting rollback process for $PROJECT_NAME in $ENVIRONMENT environment..."
    
    # Rollback Docker Compose deployment
    rollback_docker_compose
    
    # Rollback infrastructure
    rollback_infrastructure
    
    # Clean up AWS resources
    cleanup_aws_resources
    
    print_color "${GREEN}" "Rollback completed successfully!"
}

# Run main function
main 