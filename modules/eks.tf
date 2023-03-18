# Create security group for EKS Cluster

resource "aws_security_group" "eks_sg" {
  name        = var.eks_sg.name
  description = var.eks_sg.description
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = var.eks_sg.eks_from_port
    to_port     = var.eks_sg.eks_to_port
    protocol    = "tcp"
    cidr_blocks = var.eks_cidr_block
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = var.tags.sg
  }
}

# Create IAM role for eks nodes

resource "aws_iam_role" "eks_nodes_role" {
  name = "eks-nodes-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

# Attach required policies to eks node role

resource "aws_iam_role_policy_attachment" "eks_node_AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_nodes_role.name
}

resource "aws_iam_role_policy_attachment" "eks_node_AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_nodes_role.name
}

resource "aws_iam_role_policy_attachment" "eks_node_AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_nodes_role.name
}

# Create IAM role for eks cluster

resource "aws_iam_role" "eks_cluster_role" {
  name = "eks_cluster_role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

# Attach required policies to eks cluster role

resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eks_cluster_role.name
}


# Create EKS Cluster

resource "aws_eks_cluster" "eks_cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    security_group_ids = [aws_security_group.eks_sg.id]
    subnet_ids = [aws_subnet.private_subnets[var.private_subnets.eks-private-1.key].id, aws_subnet.private_subnets[var.private_subnets.eks-private-2.key].id]
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.eks_cluster_AmazonEKSVPCResourceController,
  ]
}

# Create EKS Cluster node group

resource "aws_eks_node_group" "eks-node-group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "altschool-exam-eks-node-group"
  node_role_arn   = aws_iam_role.eks_nodes_role.arn
  instance_types = ["t2.medium"]
  subnet_ids      = [aws_subnet.private_subnets[var.private_subnets.eks-private-1.key].id, aws_subnet.private_subnets[var.private_subnets.eks-private-2.key].id]

  scaling_config {
    desired_size = 4
    max_size     = 10
    min_size     = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_node_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks_node_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks_node_AmazonEC2ContainerRegistryReadOnly,
  ]
}

