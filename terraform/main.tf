provider "aws" {
  region = var.region
}

module "networking" {
  source           = "./modules/networking"
  vpc_cidr_block   = var.vpc_cidr_block
}

module "security_group" {
  source      = "./modules/security_group"
  vpc_id      = module.networking.vpc_id
  allowed_ips = var.allowed_ips
}

module "ec2_instance" {
  source            = "./modules/ec2"
  ami               = var.ami
  instance_type     = var.instance_type
  key_name          = aws_key_pair.deployer_key.key_name
  security_group_id = module.security_group.security_group_id
  subnet_id         = module.networking.public_subnet_id
}

resource "aws_key_pair" "deployer_key" {
  key_name   = "deployer_key"
  public_key = file(var.public_key_path)
}

# Dynamically fetch existing Internet Gateway
data "aws_internet_gateway" "existing" {
  filter {
    name   = "attachment.vpc-id"
    values = [module.networking.vpc_id]
  }
}

# Create a new Internet Gateway only if one doesn't already exist
resource "aws_internet_gateway" "igw" {
  count = length(data.aws_internet_gateway.existing.id) == 0 ? 1 : 0

  vpc_id = module.networking.vpc_id
  tags = {
    Name = "MainIGW"
  }
}

# Public Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = module.networking.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = coalesce(data.aws_internet_gateway.existing.id, aws_internet_gateway.igw[0].id)

  }

  tags = {
    Name = "PublicRouteTable"
  }
}

# Associate Public Subnet with Route Table
resource "aws_route_table_association" "public_rt_assoc" {
  subnet_id      = module.networking.public_subnet_id
  route_table_id = aws_route_table.public_rt.id
}