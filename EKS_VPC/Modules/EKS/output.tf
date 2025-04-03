output "eks_cluster_endpoint" {
  value = aws_eks_cluster.first_cluster.endpoint
}

output "eks_cluster_certifcate_authority_data" {
  description = "Certificate authority data for the EKS cluster"
  value = aws_eks_cluster.first_cluster.certificate_authority[0].data 
}

output "eks_cluster_id" {
  value = aws_eks_cluster.first_cluster.id
}

output "eks_cluster_name" {
  value = aws_eks_cluster.first_cluster.name
}