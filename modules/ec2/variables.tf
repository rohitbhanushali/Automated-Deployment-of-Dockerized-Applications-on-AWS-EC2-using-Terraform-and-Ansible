variable "ami" {
  description = "Amazon Machine Image ID for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "Type of EC2 instance to launch"
  type        = string
}

variable "key_name" {
  description = "Name of the SSH key pair"
  type        = string
}

variable "security_group_ids" {
  description = "List of security group IDs to associate with the instance"
  type        = list(string)
}

variable "subnet_id" {
  description = "ID of the subnet where the EC2 instance will be launched"
  type        = string
}

variable "tags" {
  description = "Tags to assign to the EC2 instance"
  type        = map(string)
}