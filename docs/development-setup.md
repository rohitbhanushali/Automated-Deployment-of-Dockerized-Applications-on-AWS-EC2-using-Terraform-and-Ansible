# Development Environment Setup Guide

This guide will help you set up your local development environment for contributing to this project.

## Prerequisites

1. **Git**
   - Install Git from [https://git-scm.com/downloads](https://git-scm.com/downloads)
   - Configure your Git identity:
     ```bash
     git config --global user.name "Your Name"
     git config --global user.email "your.email@example.com"
     ```

2. **Python 3.x**
   - Install Python from [https://www.python.org/downloads/](https://www.python.org/downloads/)
   - Verify installation:
     ```bash
     python --version
     pip --version
     ```

3. **AWS CLI**
   - Install AWS CLI from [https://aws.amazon.com/cli/](https://aws.amazon.com/cli/)
   - Configure AWS credentials:
     ```bash
     aws configure
     ```

4. **Terraform**
   - Download Terraform from [https://www.terraform.io/downloads.html](https://www.terraform.io/downloads.html)
   - Add Terraform to your PATH
   - Verify installation:
     ```bash
     terraform --version
     ```

5. **Ansible**
   - Install Ansible using pip:
     ```bash
     pip install ansible
     ```
   - Verify installation:
     ```bash
     ansible --version
     ```

6. **Docker**
   - Install Docker from [https://www.docker.com/products/docker-desktop](https://www.docker.com/products/docker-desktop)
   - Verify installation:
     ```bash
     docker --version
     docker-compose --version
     ```

## Local Development Setup

1. **Clone the Repository**
   ```bash
   git clone <repository-url>
   cd <repository-directory>
   ```

2. **Create Python Virtual Environment**
   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   pip install -r ansible/requirements.txt
   ```

3. **Configure AWS Credentials**
   - Create an IAM user with appropriate permissions
   - Configure AWS CLI with the credentials
   - Set up AWS profile for development:
     ```bash
     aws configure --profile development
     ```

4. **Generate SSH Key Pair**
   ```bash
   ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa
   ```

5. **Set Environment Variables**
   ```bash
   export PROJECT_NAME=dev-docker-app
   export ENVIRONMENT=development
   export REGION=ap-south-1
   export SSH_KEY_PATH=~/.ssh/id_rsa.pub
   ```

## Development Workflow

1. **Create a New Branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make Changes**
   - Follow the project's coding standards
   - Write tests for new features
   - Update documentation as needed

3. **Test Locally**
   ```bash
   # Validate Terraform
   cd terraform
   terraform init
   terraform plan

   # Validate Ansible
   cd ../ansible
   ansible-lint playbook.yml
   yamllint playbook.yml
   ```

4. **Commit Changes**
   ```bash
   git add .
   git commit -m "Description of your changes"
   ```

5. **Push Changes**
   ```bash
   git push origin feature/your-feature-name
   ```

6. **Create Pull Request**
   - Go to GitHub repository
   - Click "New Pull Request"
   - Select your branch
   - Add description of changes
   - Submit pull request

## Testing

1. **Local Testing**
   ```bash
   # Run deployment script in dry-run mode
   ./deploy.sh --dry-run
   ```

2. **Integration Testing**
   - Create a test AWS account
   - Set up test environment variables
   - Run full deployment in test environment

## Troubleshooting

1. **Common Issues**
   - AWS credentials not configured
   - SSH key permissions incorrect
   - Python virtual environment not activated
   - Missing dependencies

2. **Debug Tools**
   - AWS CLI debug mode: `aws --debug`
   - Terraform debug: `TF_LOG=DEBUG terraform plan`
   - Ansible debug: `ansible-playbook -vvv`

## Additional Resources

- [AWS Documentation](https://docs.aws.amazon.com/)
- [Terraform Documentation](https://www.terraform.io/docs)
- [Ansible Documentation](https://docs.ansible.com/)
- [Docker Documentation](https://docs.docker.com/) 