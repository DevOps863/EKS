provider "aws" {
  region = "ap-south-1"
}


resource "random_string" "suffix" {
  length = 6
  special = false
  upper = false
}

module "VPC" {
  source = "./EKS_VPC/Modules/VPC"
  vpc_cidr = "10.0.0.0/16"
  vpc_name = "eks-vpc"
  igw = "my-igw"
  public_sb_count = 2
  public_cidr = [ "10.0.1.0/24", "10.0.1.0/24" ]
  public_subnet_name = "public-subnet"
  private_subnet_name = "private-subnet"
  private_cidr = [ "10.0.3.0/24", "10.0.4.0/24" ]
  private_sb_count = 2
}

module "EKS" {
  source = "./EKS_VPC/Modules/EKS"
  cluster_name = "my-eks-cluster-${random_string.suffix.result}"
  eks_sg_id = module.VPC.eks_sg_id
  aws_public_subnet = module.VPC.aws_public_subnet
  node_group_name = "Project-eks"
  instance_types = ["t3.small"]
  key_pair = file("~/.ssh/id_rsa.pub") // update the path for key pair
  scaling_desired_size = 2
  scaling_max_size = 3
  scaling_min_size = 1
}