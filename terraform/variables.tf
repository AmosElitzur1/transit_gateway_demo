### provider configuration:
variable "first_region" {
  type        = string
  description = "AWS Region of first account"
}

variable "second_region" {
  type        = string
  description = "AWS Region of second account"
}

variable "assume_role_arn" {
  type        = string
  description = "Arn of IAM Role that can access to second account"
}

### networking:

variable "first_vpc_cidr_block" {
  type        = string
  description = "Cidr Block of the first VPC"
}

variable "first_subnet_cidr_block" {
  type        = string
  description = "Cidr Block of the private subnet in the first VPC"
}

variable "second_vpc_cidr_block" {
  type        = string
  description = "Cidr Block of the second VPC"
}

variable "second_subnet_cidr_blocks" {
  type        = list(string)
  description = "Cidr Blocks of the private subnets in the second VPC"
}

### transit gateway: 

variable "first_transit_gateway_name" {
  description = "Name of the transit gateway provisioned in first account"
  type        = string
}

variable "first_vpc_attachment_name" {
  description = "Name of the tgw vpc attachment provisioned in the first account"
  type        = string
}

variable "second_transit_gateway_name" {
  description = "Name of the transit gateway provisioned in second account"
  type        = string
}

variable "second_vpc_attachment_name" {
  description = "Name of the tgw vpc attachment provisioned in the second account"
  type        = string
}

variable "peering_attachment_name" {
  description = "Name of the transit gateway peering attachment"
  type        = string
}

### database instance:

variable "db_name" {
  description = "Name of database that is created in the db-instance"
  type        = string
}
