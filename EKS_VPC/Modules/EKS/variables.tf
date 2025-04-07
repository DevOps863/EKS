variable "cluster_name" {
  description = "Enter the cluster name"
  type = string
}

variable "aws_public_subnet" {
  description = "Enter the public subnet CIDR"
  type = list(string)
}

variable "eks_sg_id" {
  description = "Enter the sg id"
  type = string
}

variable "node_group_name" {
  description = "ENter the value for node_group_name"
  type = string
}

variable "instance_types" {
  description = "select the instance type"
  type = list(string)
  default = [ "t3.medium" ]
}

variable "key_pair" {
  description = "provide the ec2 keypair for login"
  type = string
}

variable "scaling_desired_size" {
  type = number
}

variable "scaling_max_size" {
  type = number
}

variable "scaling_min_size" {
  type = number
}

variable "endpoint_private_access" {
  type = bool
  default = false
}

variable "endpoint_public_access" {
  type = bool
  default = false
}

variable "public_access_cidrs" {
  type = list(string)
  default = [ "0.0.0.0/0" ]
}