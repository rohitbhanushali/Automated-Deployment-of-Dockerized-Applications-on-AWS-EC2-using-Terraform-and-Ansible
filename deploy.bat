@echo off
REM Comprehensive deployment script for Dockerized Applications on AWS EC2

REM Default values
set PROJECT_NAME=%PROJECT_NAME%
if "%PROJECT_NAME%"=="" set PROJECT_NAME=docker-app

set ENVIRONMENT=%ENVIRONMENT%
if "%ENVIRONMENT%"=="" set ENVIRONMENT=development

set REGION=%REGION%
if "%REGION%"=="" set REGION=ap-south-1

set SSH_KEY_PATH=%SSH_KEY_PATH%
if "%SSH_KEY_PATH%"=="" set SSH_KEY_PATH=%USERPROFILE%\.ssh\id_rsa.pub

REM Colors for output (Windows doesn't support ANSI colors by default)
set GREEN=[32m
set YELLOW=[33m
set RED=[31m
set NC=[0m

REM Print with color (Windows 10+ supports ANSI colors)
echo %GREEN%Starting deployment process for %PROJECT_NAME% in %ENVIRONMENT% environment...%NC%

REM Check if required tools are installed
echo.
echo %YELLOW%===== Checking Requirements =====%NC%
echo.

REM Check AWS CLI
where aws >nul 2>nul
if %ERRORLEVEL% neq 0 (
    echo %RED%AWS CLI is not installed. Please install it first.%NC%
    exit /b 1
)

REM Check Terraform
where terraform >nul 2>nul
if %ERRORLEVEL% neq 0 (
    echo %RED%Terraform is not installed. Please install it first.%NC%
    exit /b 1
)

REM Check Ansible
where ansible >nul 2>nul
if %ERRORLEVEL% neq 0 (
    echo %RED%Ansible is not installed. Please install it first.%NC%
    exit /b 1
)

REM Check Python
where python >nul 2>nul
if %ERRORLEVEL% neq 0 (
    echo %RED%Python is not installed. Please install it first.%NC%
    exit /b 1
)

REM Check SSH key
if not exist "%SSH_KEY_PATH%" (
    echo %RED%SSH key not found at %SSH_KEY_PATH%. Please create it first.%NC%
    exit /b 1
)

echo %GREEN%All requirements satisfied.%NC%

REM Deploy infrastructure with Terraform
echo.
echo %YELLOW%===== Deploying Infrastructure with Terraform =====%NC%
echo.

REM Navigate to Terraform directory
cd terraform

REM Initialize Terraform
echo %YELLOW%Initializing Terraform...%NC%
terraform init

REM Create terraform.tfvars file
echo %YELLOW%Creating terraform.tfvars file...%NC%
(
echo region = "%REGION%"
echo environment = "%ENVIRONMENT%"
echo project_name = "%PROJECT_NAME%"
echo public_key_path = "%SSH_KEY_PATH%"
) > terraform.tfvars

REM Plan Terraform
echo %YELLOW%Planning Terraform deployment...%NC%
terraform plan -out=tfplan

REM Apply Terraform
echo %YELLOW%Applying Terraform configuration...%NC%
terraform apply -auto-approve tfplan

REM Get outputs
echo %YELLOW%Getting Terraform outputs...%NC%
for /f "tokens=*" %%a in ('terraform output -raw public_ip') do set INSTANCE_IP=%%a

REM Return to root directory
cd ..

echo %GREEN%Infrastructure deployment completed.%NC%
echo %GREEN%EC2 Instance IP: %INSTANCE_IP%%NC%

REM Wait for instance to be ready
echo.
echo %YELLOW%===== Waiting for EC2 instance to be ready =====%NC%
echo.
echo %YELLOW%Waiting 60 seconds for the instance to initialize...%NC%
timeout /t 60 /nobreak

REM Deploy application with Ansible
echo.
echo %YELLOW%===== Deploying Application with Ansible =====%NC%
echo.

REM Navigate to Ansible directory
cd ansible

REM Set environment variables for dynamic inventory
set PROJECT_NAME=%PROJECT_NAME%
set ENVIRONMENT=%ENVIRONMENT%

REM Make the inventory script executable (not needed on Windows)
REM chmod +x ec2_inventory.py

REM Install required Python packages
echo %YELLOW%Installing required Python packages...%NC%
pip install -r requirements.txt

REM Run Ansible playbook
echo %YELLOW%Running Ansible playbook...%NC%
ansible-playbook -i ec2_inventory.py playbook.yml -v

REM Return to root directory
cd ..

echo %GREEN%Application deployment completed.%NC%

echo %GREEN%Deployment completed successfully!%NC%
echo %GREEN%You can access your application at http://%INSTANCE_IP%%NC% 