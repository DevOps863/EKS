#==============================
#        EKS Cluster          #
#==============================

resource "aws_eks_cluster" "first_cluster" {
  name = var.cluster_name
  role_arn = aws_iam_role.k8sadmin.arn 

  vpc_config {
    subnet_ids = var.aws_public_subnet
    endpoint_private_access = var.endpoint_private_access
    endpoint_public_access = var.endpoint_public_access
    public_access_cidrs = var.public_access_cidrs
    security_group_ids = [var.eks_sg_id]
  }

  depends_on = [ 
    aws_iam_role_policy_attachment.eks_cluster_policy,
    aws_iam_role_policy_attachment.eks_vpc_controller_policy,
   ]
}

resource "aws_eks_node_group" "project_eks_node_group" {
  cluster_name = aws_eks_cluster.first_cluster.id 
  node_group_name = var.node_group_name
  node_role_arn = aws_iam_role.eks_node_role.arn
  subnet_ids = var.aws_public_subnet
  instance_types = var.instance_types

  remote_access {
    source_security_group_ids = [var.eks_sg_id]
    ec2_ssh_key = var.key_pair
  }

  scaling_config {
    desired_size = var.scaling_desired_size
    max_size = var.scaling_max_size
    min_size = var.scaling_min_size
  }

  depends_on = [ 
    aws_iam_role_policy_attachment.eks_cni_policy,
    aws_iam_role_policy_attachment.eks_worker_node_policy,
    aws_iam_role_policy_attachment.ecr_readonly_policy,
   ]
}
#=======================================================
# IAM role for EKS Cluster
#=======================================================
resource "aws_iam_role" "k8sadmin" {
  name = "k8sadmin"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
        Effect = "Allow"
        Principal = {
            Service = "eks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role = aws_iam_role.k8sadmin.name
}

resource "aws_iam_role_policy_attachment" "eks_vpc_controller_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role = aws_iam_role.k8sadmin.name
}

#==============================================
# IAM role for worker nodes
#==============================================

resource "aws_iam_role" "eks_node_role" {
    name = "eks-node-group-role"
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
            Effect = "Allow"
            Principal = {
                Service = "ec2.amazonaws.com"
            }
            Action = "sts:AssumeRole"
        }]
    })
}

resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role = aws_iam_role.eks_node_role.name
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role = aws_iam_role.eks_node_role.name
}

resource "aws_iam_role_policy_attachment" "ecr_readonly_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role = aws_iam_role.eks_node_role.name
}


