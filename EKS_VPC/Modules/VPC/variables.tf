variable "vpc_cidr" {
  description = "CIDR block for the VPC"
}

variable "vpc_name" {
  description = "Enter the VPC name"
}

variable "igw" {
  description = "Enter the igw name"
}

variable "public_sb_count" {
  description = "Enter the count"
  type = number
}

variable "public_cidr" {
  description = "Enter the cidr lists"
  type = list(string)
}

variable "public_subnet_name" {
  description = "The name prefix for subnets"
  type = string
}

variable "private_sb_count" {
  description = "Enter the count"
  type = number
}

variable "private_cidr" {
  description = "Enter the cidr lists"
  type = list(string)
}

variable "private_subnet_name" {
  description = "The name prefix for subnets"
  type = string
}

