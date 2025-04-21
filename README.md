# Automated Deployment of Dockerized Applications on AWS EC2

This project demonstrates a complete automation pipeline for deploying containerized applications on AWS EC2 instances using Infrastructure as Code (IaC) and Configuration Management tools. It leverages Terraform for infrastructure provisioning and Ansible for server configuration and container orchestration.

## Architecture

The project follows a modular architecture with the following components:

1. **Infrastructure as Code (Terraform)**
   - EC2 instance provisioning
   - Security group configuration
   - Network setup
   - IAM roles and policies
   - CloudWatch monitoring and alerts

2. **Configuration Management (Ansible)**
   - Docker and Docker Compose installation
   - Application deployment
   - Service configuration
   - Health checks and monitoring
   - Log aggregation with ELK stack

3. **Application Components**
   - Nginx web server
   - Python application server
   - Docker Compose orchestration
   - Prometheus and Grafana for monitoring
   - ELK stack for log management

### Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                        AWS Cloud                                 │
│                                                                 │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐         │
│  │             │    │             │    │             │         │
│  │  VPC        │    │  Security   │    │  IAM Roles  │         │
│  │             │    │  Groups     │    │             │         │
│  └──────┬──────┘    └──────┬──────┘    └──────┬──────┘         │
│         │                  │                  │                │
│         └──────────────────┼──────────────────┘                │
│                            │                                   │
│  ┌─────────────┐    ┌──────┴──────┐    ┌─────────────┐         │
│  │             │    │             │    │             │         │
│  │ CloudWatch  │◄───┤  EC2        │◄───┤  SNS        │         │
│  │ Alarms      │    │  Instance   │    │  Topics     │         │
│  │             │    │             │    │             │         │
│  └─────────────┘    └─────────────┘    └─────────────┘         │
└─────────────────────────────────────────────────────────────────┘
                               ▲
                               │
                               ▼
┌─────────────────────────────────────────────────────────────────┐
│                        Application                              │
│                                                                 │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐         │
│  │             │    │             │    │             │         │
│  │  Nginx      │    │  Python     │    │  Docker     │         │
│  │  Web Server │    │  App Server │    │  Compose    │         │
│  │             │    │             │    │             │         │
│  └──────┬──────┘    └──────┬──────┘    └──────┬──────┘         │
│         │                  │                  │                │
│         └──────────────────┼──────────────────┘                │
│                            │                                   │
│  ┌─────────────┐    ┌──────┴──────┐    ┌─────────────┐         │
│  │             │    │             │    │             │         │
│  │ Prometheus  │◄───┤  Grafana    │◄───┤  ELK Stack  │         │
│  │             │    │             │    │             │         │
│  └─────────────┘    └─────────────┘    └─────────────┘         │
└─────────────────────────────────────────────────────────────────┘
```

### CI/CD Pipeline Diagram

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│             │     │             │     │             │
│  Code Push  │────►│  Validation │────►│  Security   │
│             │     │             │     │  Scanning   │
└─────────────┘     └─────────────┘     └──────┬──────┘
                                                │
                                                ▼
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│             │     │             │     │             │
│  Rollback   │◄────┤  Verify     │◄────┤  Deploy     │
│             │     │  Deployment │     │             │
└─────────────┘     └─────────────┘     └─────────────┘
```

## Prerequisites

Before using this project, ensure you have the following installed:

- AWS CLI configured with appropriate credentials
- Terraform (latest version)
- Ansible (latest version)
- Python 3.x
- SSH key pair (for EC2 instance access)
- Git

## Project Structure

```
.
├── terraform/                 # Terraform configuration files
│   ├── main.tf               # Main Terraform configuration
│   ├── variables.tf          # Variable definitions
│   ├── outputs.tf            # Output definitions
│   └── monitoring.tf         # Monitoring configuration
├── ansible/                  # Ansible configuration files
│   ├── roles/               # Ansible roles
│   │   ├── docker_setup/    # Docker installation role
│   │   └── docker_compose_deploy/ # Application deployment role
│   ├── playbook.yml         # Main Ansible playbook
│   ├── inventory.ini        # Dynamic inventory configuration
│   ├── ec2_inventory.py     # EC2 dynamic inventory script
│   ├── docker-compose.yml   # Docker Compose configuration
│   └── requirements.txt     # Python dependencies
├── scripts/                 # Deployment scripts
│   ├── verify_deployment.sh # Deployment verification script
│   └── rollback.sh         # Rollback script
├── .github/                # GitHub Actions workflows
│   └── workflows/         # CI/CD pipeline configuration
├── deploy.sh              # Unix/Linux deployment script
└── deploy.bat            # Windows deployment script
```

## Quick Reference Guide

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `PROJECT_NAME` | Name of your project | `docker-app` |
| `ENVIRONMENT` | Deployment environment | `development` |
| `REGION` | AWS region | `ap-south-1` |
| `SSH_KEY_PATH` | Path to SSH public key | `~/.ssh/id_rsa.pub` |

### Ports

| Service | Port | Description |
|---------|------|-------------|
| Nginx | 80 | Web server |
| Python App | 8000 | Application server |
| Prometheus | 9090 | Metrics collection |
| Grafana | 3000 | Metrics visualization |
| Elasticsearch | 9200 | Search engine |
| Kibana | 5601 | Log visualization |
| Logstash | 5044 | Log processing |

### Common Commands

| Command | Description |
|---------|-------------|
| `./deploy.sh` | Deploy application (Unix/Linux) |
| `deploy.bat` | Deploy application (Windows) |
| `./scripts/verify_deployment.sh <IP>` | Verify deployment |
| `./scripts/rollback.sh` | Rollback deployment |
| `terraform init` | Initialize Terraform |
| `terraform apply` | Apply Terraform configuration |
| `ansible-playbook -i ec2_inventory.py playbook.yml` | Run Ansible playbook |

## Step-by-Step Execution Guide

### 1. Initial Setup

1. **Clone the Repository**:
   ```bash
   git clone <repository-url>
   cd <repository-directory>
   ```

2. **Configure AWS Credentials**:
   ```bash
   aws configure
   # Enter your AWS Access Key ID
   # Enter your AWS Secret Access Key
   # Enter your default region (e.g., ap-south-1)
   # Enter your preferred output format (json)
   ```

3. **Generate SSH Key Pair** (if not already available):
   ```bash
   ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa
   ```

4. **Set Environment Variables**:
   ```bash
   # For Unix/Linux
   export PROJECT_NAME=my-app
   export ENVIRONMENT=development
   export REGION=ap-south-1
   export SSH_KEY_PATH=~/.ssh/id_rsa.pub

   # For Windows
   set PROJECT_NAME=my-app
   set ENVIRONMENT=development
   set REGION=ap-south-1
   set SSH_KEY_PATH=%USERPROFILE%\.ssh\id_rsa.pub
   ```

### 2. Local Development

1. **Create Python Virtual Environment**:
   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   pip install -r ansible/requirements.txt
   ```

2. **Validate Terraform Configuration**:
   ```bash
   cd terraform
   terraform init
   terraform plan
   ```

3. **Validate Ansible Playbook**:
   ```bash
   cd ansible
   ansible-lint playbook.yml
   yamllint playbook.yml
   ```

### 3. Deployment

#### Option 1: Using Deployment Scripts

1. **For Unix/Linux Users**:
   ```bash
   chmod +x deploy.sh
   ./deploy.sh
   ```

2. **For Windows Users**:
   ```batch
   deploy.bat
   ```

#### Option 2: Manual Deployment

1. **Deploy Infrastructure with Terraform**:
   ```bash
   cd terraform
   terraform init
   terraform apply -auto-approve
   ```

2. **Deploy Application with Ansible**:
   ```bash
   cd ansible
   chmod +x ec2_inventory.py
   pip install -r requirements.txt
   ansible-playbook -i ec2_inventory.py playbook.yml
   ```

### 4. Verification and Monitoring

1. **Verify Deployment**:
   ```bash
   chmod +x scripts/verify_deployment.sh
   ./scripts/verify_deployment.sh <EC2_INSTANCE_IP>
   ```

2. **Access Monitoring Dashboards**:
   - Prometheus: http://<EC2_INSTANCE_IP>:9090
   - Grafana: http://<EC2_INSTANCE_IP>:3000
   - Kibana: http://<EC2_INSTANCE_IP>:5601

### 5. Rollback (if needed)

1. **Execute Rollback Script**:
   ```bash
   chmod +x scripts/rollback.sh
   ./scripts/rollback.sh
   ```

## CI/CD Pipeline

The project includes a GitHub Actions workflow that automates the deployment process:

1. **Validation Stage**:
   - Ansible playbook validation
   - Terraform configuration validation

2. **Security Stage**:
   - Trivy vulnerability scanning
   - Dependency checks

3. **Deployment Stage**:
   - Infrastructure provisioning
   - Application deployment
   - Health verification
   - Automatic rollback on failure

## Monitoring and Maintenance

The deployed application includes:

- Health checks for all services
- Resource limits and reservations
- Logging configuration
- Automatic restart policies
- CloudWatch alarms for:
  - CPU utilization
  - Memory usage
  - Disk space
- ELK stack for log aggregation
- Prometheus and Grafana for metrics

## Security Considerations

- EC2 instances are deployed in a VPC with appropriate security groups
- SSH access is restricted to specific IP ranges
- Docker containers run with limited privileges
- Sensitive information is managed through environment variables
- Regular security scanning through CI/CD pipeline

## Troubleshooting

Common issues and solutions:

1. **SSH Connection Issues**:
   - Verify SSH key permissions
   - Check security group rules
   - Ensure instance is running

2. **Docker Deployment Failures**:
   - Check Docker service status
   - Verify Docker Compose configuration
   - Review container logs

3. **Ansible Playbook Errors**:
   - Check Python dependencies
   - Verify inventory configuration
   - Review Ansible logs

4. **Monitoring Issues**:
   - Verify CloudWatch agent status
   - Check Prometheus targets
   - Review ELK stack logs

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details. 