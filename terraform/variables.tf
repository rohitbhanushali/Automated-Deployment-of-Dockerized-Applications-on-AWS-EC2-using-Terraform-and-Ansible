variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "environment" {
  description = "Environment name for tagging"
  type        = string
  default     = "development"
}

variable "project_name" {
  description = "Name of the project for tagging"
  type        = string
  default     = "docker-app"
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "allowed_ips" {
  description = "List of CIDR blocks allowed to access the instance"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "app_port" {
  description = "Port number for the application"
  type        = number
  default     = 8000
}

variable "ami" {
  description = "Amazon Machine Image ID"
  type        = string
  default     = "ami-0f1dcc636b69a6438" # Amazon Linux 2
}

variable "instance_type" {
  description = "Type of EC2 instance"
  type        = string
  default     = "t2.micro"
}

variable "instance_name" {
  description = "Name tag for the EC2 instance"
  default     = "AppInstance"
}

variable "public_key_path" {
  description = "Path to the SSH public key"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}