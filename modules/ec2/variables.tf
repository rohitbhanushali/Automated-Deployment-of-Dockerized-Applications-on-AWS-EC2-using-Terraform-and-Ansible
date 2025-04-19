variable "ami" {}
variable "instance_type" {}
variable "key_name" {}
variable "security_groups" {
  type = list(string)
}
variable "tags" {
  type = map(string)
}