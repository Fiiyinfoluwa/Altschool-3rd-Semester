terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
    }
  }
}

provider "kubernetes" {
  host                   = aws_eks_cluster.eks_cluster.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.eks_cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster-auth.token
}

provider "kubectl" {
  host                   = aws_eks_cluster.eks_cluster.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.eks_cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster-auth.token
  load_config_file       = false
}

provider "helm" {
  kubernetes {
    host                   = aws_eks_cluster.eks_cluster.endpoint
    cluster_ca_certificate = base64decode(aws_eks_cluster.eks_cluster.certificate_authority.0.data)
    token                  = data.aws_eks_cluster_auth.cluster-auth.token
  }
}


# provider "aws" {
#   region     = "us-east-1"
# }

# terraform {
#   required_providers {
#     kubectl = {
#       source = "gavinbunney/kubectl"
#       version = "1.14.0"
#     }
#     helm = {
#       source = "hashicorp/helm"
#       #version = "2.5.1"
#       version = "~> 2.5"
#     }
#     namedotcom = {
#       source  = "lexfrei/namedotcom"
#       version = "1.2.5"
#     }
#     http = {
#       source = "hashicorp/http"
#       #version = "2.1.0"
#       version = "~> 2.1"
#     }
#     kubernetes = {
#       source  = "hashicorp/kubernetes"
#       version = "~> 2.11"
#     }
#   }
# }

# provider "namedotcom" {
#   username = var.namedotcom_username
#   token = var.namedotcom_token
# }

# data "aws_eks_cluster" "eks-cluster" {
#   name = "altschool-exam-eks-cluster"

#   depends_on = [
#     aws_eks_cluster.eks_cluster
#   ]
# }

# provider "kubernetes" {
#   host                   = aws_eks_cluster.eks_cluster.endpoint
#   cluster_ca_certificate = base64decode(aws_eks_cluster.eks_cluster.certificate_authority.0.data)
#   token                  = data.aws_eks_cluster_auth.cluster-auth.token
# }



# data "aws_eks_cluster_auth" "cluster-auth" {
#   depends_on = [aws_eks_cluster.eks_cluster]
#   name       = aws_eks_cluster.eks_cluster.name
# }

# provider "helm" {
#   kubernetes {
#     host                   = aws_eks_cluster.eks_cluster.endpoint
#     cluster_ca_certificate = base64decode(aws_eks_cluster.eks_cluster.certificate_authority.0.data)
#     token                  = data.aws_eks_cluster_auth.cluster-auth.token
#   }
# }

