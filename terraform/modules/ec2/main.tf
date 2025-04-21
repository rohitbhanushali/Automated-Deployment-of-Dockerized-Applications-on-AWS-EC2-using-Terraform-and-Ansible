# Create EC2 Instance
resource "aws_instance" "ec2" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  associate_public_ip_address = true
  key_name               = var.key_name
  vpc_security_group_ids = [var.security_group_id]
  
  # Add root volume configuration
  root_block_device {
    volume_size           = var.root_volume_size
    volume_type           = var.root_volume_type
    delete_on_termination = true
    encrypted             = true
  }

  # Add user data script for initial setup
  user_data = <<-EOF
              #!/bin/bash
              # Update system packages
              yum update -y
              
              # Install Docker
              yum install -y docker
              systemctl start docker
              systemctl enable docker
              
              # Install Docker Compose
              curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
              chmod +x /usr/local/bin/docker-compose
              
              # Add ec2-user to docker group
              usermod -a -G docker ec2-user
              
              # Create app directory
              mkdir -p /home/ec2-user/app
              chown -R ec2-user:ec2-user /home/ec2-user/app
              EOF

  tags = {
    Name        = "${var.project_name}-instance"
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "terraform"
  }

  # Add lifecycle policy to prevent replacement during updates
  lifecycle {
    create_before_destroy = true
  }
}

# Create EBS volume for persistent storage
resource "aws_ebs_volume" "app_data" {
  availability_zone = aws_instance.ec2.availability_zone
  size              = var.data_volume_size
  type              = var.data_volume_type
  encrypted         = true

  tags = {
    Name        = "${var.project_name}-data-volume"
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "terraform"
  }
}

# Attach EBS volume to EC2 instance
resource "aws_volume_attachment" "app_data_attachment" {
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.app_data.id
  instance_id = aws_instance.ec2.id
}

output "ec2_instance_id" {
  value = aws_instance.ec2.id
}

output "ec2_public_ip" {
  value = aws_instance.ec2.public_ip
}