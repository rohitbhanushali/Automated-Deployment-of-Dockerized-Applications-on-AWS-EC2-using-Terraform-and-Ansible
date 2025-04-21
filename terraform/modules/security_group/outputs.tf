output "security_group_id" {
  description = "ID of the security group"
  value       = aws_security_group.sg.id
}

output "security_group_name" {
  description = "Name of the security group"
  value       = aws_security_group.sg.name
}

output "security_group_arn" {
  description = "ARN of the security group"
  value       = aws_security_group.sg.arn
}