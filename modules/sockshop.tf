

# Create kubernetes Name space for socks shop app

resource "kubernetes_namespace" "kube-namespace-socks" {
  metadata {
    name = "sock-shop"
  }
}

# Create kubernetes deployment for socks shop app

resource "kubectl_manifest" "kube-deployment-socks" {
    for_each  = data.kubectl_file_documents.docs.manifests
    yaml_body = each.value

    depends_on = [kubernetes_namespace.kube-namespace-socks]
}

resource "kubectl_manifest" "kube-deployment-socks-ingress" {
    for_each  = data.kubectl_file_documents.ingress.manifests
    yaml_body = each.value

    depends_on = [kubectl_manifest.kube-deployment-socks, helm_release.nginx-ingress-controller]
}

