variable "region" {
  description = "AWS region"
  default     = "ap-south-1"
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "allowed_ips" {
  description = "IP ranges allowed to access the EC2 instance"
  type        = list(string)
  default     = ["0.0.0.0/0"] # Change to your specific IP range for better security
}

variable "ami" {
  description = "Amazon Machine Image ID"
  default     = "ami-0f1dcc636b69a6438" # Amazon Linux 2
}

variable "instance_type" {
  description = "Type of EC2 instance"
  default     = "t2.micro"
}

variable "instance_name" {
  description = "Name tag for the EC2 instance"
  default     = "AppInstance"
}

variable "public_key_path" {
  description = "Path to the SSH public key"
  default     = "C:/Users/Dell/.ssh/id_rsa.pub"
}