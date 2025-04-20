provider "aws" {
  region = var.region
}

module "networking" {
  source          = "./modules/networking"
  vpc_cidr_block  = var.vpc_cidr_block
}

module "ec2_instance" {
  source            = "./modules/ec2"
  ami               = var.ami
  instance_type     = var.instance_type
  key_name          = aws_key_pair.deployer_key.key_name
  security_group_ids = [module.security_group.id]
  subnet_id         = module.networking.public_subnet_id
  tags = {
    Name = var.instance_name
  }
}

module "security_group" {
  source      = "./modules/security_group"
  vpc_id      = module.networking.vpc_id
  allowed_ips = var.allowed_ips
}

resource "aws_key_pair" "deployer_key" {
  key_name   = "deployer_key"
  public_key = file(var.public_key_path)
}

resource "aws_internet_gateway" "igw" {
  vpc_id = module.networking.vpc_id
}

resource "aws_route_table" "public_rt" {
  vpc_id = module.networking.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public_rt_assoc" {
  subnet_id      = module.networking.public_subnet_id
  route_table_id = aws_route_table.public_rt.id
}