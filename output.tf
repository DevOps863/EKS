output "eks_cluster_id" {
  value = module.EKS.eks_cluster_id
}

output "eks_cluster_endpoint" {
  value = module.EKS.eks_cluster_endpoint
}

output "cluster_name" {
  value = module.EKS.eks_cluster_name
}

output "aws_public_subnet" {
  value = module.VPC.aws_public_subnet
}

output "vpc_id" {
  value = module.VPC.vpc_id
}