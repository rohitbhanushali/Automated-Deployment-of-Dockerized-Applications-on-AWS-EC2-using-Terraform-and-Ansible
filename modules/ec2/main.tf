resource "aws_instance" "ec2" {
  ami               = var.ami
  instance_type     = var.instance_type
  key_name          = var.key_name
  security_groups   = var.security_group_ids
  subnet_id         = var.subnet_id

  tags = var.tags
}

output "public_ip" {
  value = aws_instance.ec2.public_ip
}

output "instance_id" {
  value = aws_instance.ec2.id
}