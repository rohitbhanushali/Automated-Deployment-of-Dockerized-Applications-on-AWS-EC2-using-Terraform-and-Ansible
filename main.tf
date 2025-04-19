provider "aws" {
  region = var.region
}

module "ec2_instance" {
  source           = "./modules/ec2"
  instance_type    = var.instance_type
  ami              = var.ami
  key_name         = aws_key_pair.deployer_key.key_name
  security_groups  = [module.security_group.name]
  tags             = {
    Name = var.instance_name
  }
}

module "security_group" {
  source      = "./modules/security_group"
  group_name  = "allow_ssh"
  descriptions = "Allow SSH inbound traffic"
  ingress_rules = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

resource "aws_key_pair" "deployer_key" {
  key_name   = "deployer_key"
  public_key = file(var.public_key_path)
}