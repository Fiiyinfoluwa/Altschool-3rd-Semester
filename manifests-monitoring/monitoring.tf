terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
    }
  }
}

provider "kubectl" {
  host                   = aws_eks_cluster.eks_cluster.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.eks_cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster-auth.token
  load_config_file       = false
}

data "kubectl_path_documents" "docs" {
    pattern = "./*.yaml"
}

resource "kubectl_manifest" "monitoring" {
    for_each  = toset(data.kubectl_path_documents.docs.documents)
    yaml_body = each.value
}