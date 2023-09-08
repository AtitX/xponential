variable "aws_region" {
  description = "Region in which AWS Resources to be created"
  type = string
  default = "ap-southeast-1"
}

variable "profile" {
  type = string
}

variable "base_name" {
  type = string
}

variable "additional_tags" {
  default = {}
  description = "Additional resource tags"
  type = map(string)
}

variable "vpc_single_nat_gateway" {}
variable "vpc_enable_nat_gateway" {}
variable "vpc_cidr" {}
variable "vpc_create_database_subnet_group" {}
variable "vpc_create_database_subnet_route_table" {}
variable "instance_type" {
  
}
variable "environment" {
  
}
variable "owner" {
  
}