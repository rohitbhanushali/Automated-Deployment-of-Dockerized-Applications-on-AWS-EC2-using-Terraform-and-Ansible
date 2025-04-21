output "security_group_id" {
  value = module.security_group.security_group_id
}

output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.ec2.id
}

output "public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.ec2.public_ip
}

output "private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = aws_instance.ec2.private_ip
}

output "availability_zone" {
  description = "Availability zone of the EC2 instance"
  value       = aws_instance.ec2.availability_zone
}

output "data_volume_id" {
  description = "ID of the attached EBS volume"
  value       = aws_ebs_volume.app_data.id
}