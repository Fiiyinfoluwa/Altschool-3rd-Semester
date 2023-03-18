# EKS Cluster Outputs
output "cluster_id" {
  description = "The name/id of the EKS cluster."
  value       = aws_eks_cluster.eks_cluster.id
}

output "vpc_id" {
  description = "The VPC ID of the EKS cluster."
  value       = aws_eks_cluster.eks_cluster.vpc_config[0].vpc_id
}

output "cluster_version" {
  description = "The Kubernetes server version for the EKS cluster."
  value       = aws_eks_cluster.eks_cluster.version
}

output "endpoint" {
  value = aws_eks_cluster.eks_cluster.endpoint
}

