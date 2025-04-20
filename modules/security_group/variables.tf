variable "vpc_id" {
  description = "ID of the VPC where the security group will be created"
  type        = string
}

variable "allowed_ips" {
  description = "List of CIDR blocks allowed to access the resources"
  type        = list(string)
}