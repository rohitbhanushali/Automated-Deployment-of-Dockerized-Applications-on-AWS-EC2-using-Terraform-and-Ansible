#!/bin/bash

# Exit on error
set -e

# Default values
INSTANCE_IP=${1:-""}
MAX_RETRIES=30
RETRY_INTERVAL=10

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

# Check if instance IP is provided
if [ -z "$INSTANCE_IP" ]; then
    print_color "${RED}" "Error: Instance IP is required"
    exit 1
fi

# Function to check service health
check_service() {
    local service=$1
    local port=$2
    local endpoint=$3
    local retries=$4
    local interval=$5

    print_color "${YELLOW}" "Checking $service on port $port..."
    
    for ((i=1; i<=retries; i++)); do
        if curl -s "http://${INSTANCE_IP}:${port}${endpoint}" > /dev/null; then
            print_color "${GREEN}" "$service is healthy"
            return 0
        fi
        print_color "${YELLOW}" "Attempt $i/$retries: $service is not ready yet. Waiting $interval seconds..."
        sleep $interval
    done
    
    print_color "${RED}" "$service failed health check after $retries attempts"
    return 1
}

# Main verification process
print_color "${YELLOW}" "Starting deployment verification..."

# Check Nginx
check_service "Nginx" "80" "/" $MAX_RETRIES $RETRY_INTERVAL || exit 1

# Check Python application
check_service "Python App" "8000" "/" $MAX_RETRIES $RETRY_INTERVAL || exit 1

# Check Prometheus
check_service "Prometheus" "9090" "/-/healthy" $MAX_RETRIES $RETRY_INTERVAL || exit 1

# Check Grafana
check_service "Grafana" "3000" "/api/health" $MAX_RETRIES $RETRY_INTERVAL || exit 1

# Check Elasticsearch
check_service "Elasticsearch" "9200" "/_cluster/health" $MAX_RETRIES $RETRY_INTERVAL || exit 1

# Check Kibana
check_service "Kibana" "5601" "/api/status" $MAX_RETRIES $RETRY_INTERVAL || exit 1

print_color "${GREEN}" "All services are healthy! Deployment verification completed successfully." 