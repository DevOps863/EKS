output "aws_public_subnet" {
  description = "List the public subnets available"
  value = aws_subnet.project_eks_public_subnet[*].id 
}

output "aws_private_subnet" {
  description = "List all the private subnets"
  value = aws_subnet.project_eks_private_subnet[*].id
}

output "vpc_id" {
  description = "List the VPC IP"
  value = aws_vpc.project_eks.id
}

output "eks_sg_id" {
  value = aws_security_group.EKS-SG.id
  description = "The security group ID for EKS"
}
