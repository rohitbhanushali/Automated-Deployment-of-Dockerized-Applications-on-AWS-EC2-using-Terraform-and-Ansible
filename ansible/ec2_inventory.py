#!/usr/bin/env python3
"""
Dynamic inventory script for Ansible to discover EC2 instances.
This script queries AWS EC2 and returns inventory in JSON format.
"""

import argparse
import boto3
import json
import os
import sys

def get_ec2_instances():
    """Get EC2 instances based on tags."""
    # Get environment variables or use defaults
    project_name = os.environ.get('PROJECT_NAME', 'docker-app')
    environment = os.environ.get('ENVIRONMENT', 'development')
    
    # Create EC2 client
    ec2 = boto3.client('ec2')
    
    # Filter instances by tags
    response = ec2.describe_instances(
        Filters=[
            {
                'Name': 'tag:Project',
                'Values': [project_name]
            },
            {
                'Name': 'tag:Environment',
                'Values': [environment]
            },
            {
                'Name': 'instance-state-name',
                'Values': ['running']
            }
        ]
    )
    
    # Process instances
    instances = []
    for reservation in response['Reservations']:
        for instance in reservation['Instances']:
            # Get instance name from tags
            name = instance['InstanceId']
            for tag in instance.get('Tags', []):
                if tag['Key'] == 'Name':
                    name = tag['Value']
                    break
            
            # Get SSH key name
            key_name = instance.get('KeyName', 'default')
            
            # Add instance to list
            instances.append({
                'id': instance['InstanceId'],
                'name': name,
                'public_ip': instance.get('PublicIpAddress', ''),
                'private_ip': instance.get('PrivateIpAddress', ''),
                'key_name': key_name
            })
    
    return instances

def generate_inventory():
    """Generate inventory in Ansible format."""
    instances = get_ec2_instances()
    
    # Create inventory structure
    inventory = {
        '_meta': {
            'hostvars': {}
        },
        'ec2': {
            'hosts': []
        }
    }
    
    # Add instances to inventory
    for instance in instances:
        hostname = instance['public_ip'] or instance['private_ip']
        if not hostname:
            continue
            
        # Add to hosts list
        inventory['ec2']['hosts'].append(hostname)
        
        # Add host variables
        inventory['_meta']['hostvars'][hostname] = {
            'ansible_host': hostname,
            'ansible_user': 'ec2-user',  # Default for Amazon Linux 2
            'ansible_ssh_private_key_file': f"~/.ssh/{instance['key_name']}.pem",
            'instance_id': instance['id'],
            'instance_name': instance['name']
        }
    
    return inventory

def list_hosts():
    """List hosts in simple format."""
    instances = get_ec2_instances()
    for instance in instances:
        hostname = instance['public_ip'] or instance['private_ip']
        if hostname:
            print(hostname)

def get_host_vars(host):
    """Get variables for a specific host."""
    instances = get_ec2_instances()
    for instance in instances:
        hostname = instance['public_ip'] or instance['private_ip']
        if hostname == host:
            return {
                'ansible_host': hostname,
                'ansible_user': 'ec2-user',  # Default for Amazon Linux 2
                'ansible_ssh_private_key_file': f"~/.ssh/{instance['key_name']}.pem",
                'instance_id': instance['id'],
                'instance_name': instance['name']
            }
    return {}

def main():
    """Main function to handle command line arguments."""
    parser = argparse.ArgumentParser(description='Dynamic inventory script for EC2 instances')
    group = parser.add_mutually_exclusive_group()
    group.add_argument('--list', action='store_true', help='List all hosts')
    group.add_argument('--host', help='Get variables for a specific host')
    
    args = parser.parse_args()
    
    if args.list:
        print(json.dumps(generate_inventory()))
    elif args.host:
        print(json.dumps(get_host_vars(args.host)))
    else:
        parser.print_help()
        sys.exit(1)

if __name__ == '__main__':
    main() 