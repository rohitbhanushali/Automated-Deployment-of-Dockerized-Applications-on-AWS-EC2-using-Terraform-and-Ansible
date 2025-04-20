variable "region" {
  description = "AWS region"
  default     = "ap-south-1"
}

variable "instance_type" {
  description = "Type of EC2 instance"
  default     = "t2.micro"
}

variable "ami" {
  description = "Amazon Machine Image ID"
  default     = "ami-0f1dcc636b69a6438" # Amazon Linux 2
}

variable "instance_name" {
  description = "Name tag for the EC2 instance"
  default     = "AppInstance"
}

variable "public_key_path" {
  description = "Path to the SSH public key"
  default     = "C:/Users/Dell/.ssh/id_rsa.pub"
}