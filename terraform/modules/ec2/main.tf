resource "aws_instance" "ec2" {
  ami                   = var.ami
  instance_type         = var.instance_type
  subnet_id             = var.subnet_id
  associate_public_ip_address = true
  key_name              = var.key_name
  vpc_security_group_ids = [var.security_group_id] # Correct usage

  tags = {
    Name = "AppInstance"
  }
}

output "ec2_instance_id" {
  value = aws_instance.ec2.id
}

output "ec2_public_ip" {
  value = aws_instance.ec2.public_ip
}