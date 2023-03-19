
resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }
}

resource "helm_release" "kube-prometheus" {
  name       = "kube-prometheus"
  namespace  = "monitoring"
  version    = var.kube-version
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"

  depends_on = [resource.kubernetes_namespace.monitoring, resource.kubectl_manifest.kube-deployment-socks-ingress]
}           


resource "helm_release" "nginx-ingress-controller" {
  name       = "nginx-ingress-controller"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "nginx-ingress-controller"


  set {
    name  = "service.type"
    value = "LoadBalancer"
  }
}


resource "kubectl_manifest" "kube-deployment-prometheus-ingress" {
    for_each  = data.kubectl_file_documents.prometheus-ingress.manifests
    yaml_body = each.value

    depends_on = [helm_release.kube-prometheus]
}

# resource "helm_release" "prometheus-nginx-exporter" {
#   name       = "prometheus-nginx-exporter"
#   namespace  = "monitoring"
#   version    = "0.1.0"
#   repository = "https://prometheus-community.github.io/helm-charts"
#   chart      = "prometheus-nginx-exporter"

#   depends_on = [resource.kubernetes_namespace.monitoring]
# }

resource "helm_release" "grafana-loki" {
  name       = "kube-prometheus-stack"
  namespace  = "monitoring"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "loki-stack"

  depends_on = [resource.kubernetes_namespace.monitoring]
}