@echo off
REM Script to run the Ansible playbook with dynamic inventory on Windows

REM Set environment variables
set PROJECT_NAME=%PROJECT_NAME%
if "%PROJECT_NAME%"=="" set PROJECT_NAME=docker-app

set ENVIRONMENT=%ENVIRONMENT%
if "%ENVIRONMENT%"=="" set ENVIRONMENT=development

REM Install required Python packages
pip install -r requirements.txt

REM Run the Ansible playbook with dynamic inventory
ansible-playbook -i ec2_inventory.py playbook.yml %* 