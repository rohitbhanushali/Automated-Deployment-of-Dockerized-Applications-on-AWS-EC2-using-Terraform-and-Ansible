variable "security_group_id" {
  description = "The ID of the security group to associate with the EC2 instance"
  type        = string
}

variable "ami" {
  description = "The AMI to use for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "The instance type to use for the EC2 instance"
  type        = string
}

variable "key_name" {
  description = "The key pair name to use for the EC2 instance"
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet to launch the EC2 instance in"
  type        = string
}