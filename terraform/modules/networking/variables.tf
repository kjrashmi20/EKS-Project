
variable "vpc_name" {

  description = "Name of the VPC"

  type = string

}



variable "vpc_cidr" {

  description = "CIDR block for the VPC"

  type = string

}



variable "azs" {

  description = "Availability Zones for the VPC"

  type = list(string)

}



variable "public_subnets" {

  description = "CIDR blocks for public subnets"

  type = list(string)

}



variable "private_subnets" {

  description = "CIDR blocks for private subnets"

  type = list(string)

}



variable "tags" {

  description = "Tags applied to networking resources"

  type = map(string)

  default = {}

}

