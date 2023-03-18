terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
    }
  }
}

# Create kubernetes Name space for socks shop app

resource "kubernetes_namespace" "kube-namespace-portfolio" {
  metadata {
    name = "portfolio"
  }
}

resource "kubectl_manifest" "kube-deployment-portfolio" {
    for_each  = data.kubectl_file_documents.portfolio.manifests
    yaml_body = each.value

    depends_on = [kubernetes_namespace.kube-namespace-portfolio]
}


resource "kubectl_manifest" "kube-deployment-portfolio-ingress" {
    for_each  = data.kubectl_file_documents.portfolio-ingress.manifests
    yaml_body = each.value

    depends_on = [kubectl_manifest.kube-deployment-socks, helm_release.nginx-ingress-controller]
}