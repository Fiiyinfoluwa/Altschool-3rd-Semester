data "aws_eks_cluster" "eks-cluster" {
  name = "altschool-exam-eks-cluster"

  depends_on = [
    aws_eks_cluster.eks_cluster
  ]
}

data "aws_eks_cluster_auth" "cluster-auth" {
  depends_on = [aws_eks_cluster.eks_cluster]
  name       = aws_eks_cluster.eks_cluster.name
}

data "kubernetes_service" "nginx-service"{
  metadata {
    name = "nginx-ingress-controller"
  }

  depends_on = [
    helm_release.nginx-ingress-controller
  ]
}

data "kubectl_file_documents" "prometheus-ingress" {
    content = file("prometheus.yaml")
}
    