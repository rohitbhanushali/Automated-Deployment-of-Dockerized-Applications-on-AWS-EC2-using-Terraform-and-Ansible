variable "vpc_id" {
  description = "ID of the VPC where the security group will be created"
  type        = string
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