output "instance_public_ip" {
  description = "The public IP address of the EC2 instance"
  value       = module.ec2_instance.public_ip
}

output "instance_id" {
  description = "The ID of the EC2 instance"
  value       = module.ec2_instance.instance_id
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.networking.vpc_id
}

output "public_subnet_id" {
  description = "The ID of the public subnet"
  value       = module.networking.public_subnet_id
}

output "security_group_id" {
  description = "The ID of the security group"
  value       = module.security_group.id
}