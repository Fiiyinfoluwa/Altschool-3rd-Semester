resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }
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

resource "helm_release" "kube-prometheus" {
  name       = "kube-prometheus-stack"
  namespace  = "monitoring"
  version    = var.kube-version
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"

  depends_on = [resource.kubernetes_namespace.monitoring, resource.kubectl_manifest.kube-deployment-socks-ingress]
}           



resource "kubectl_manifest" "kube-deployment-prometheus-ingress" {
    for_each  = data.kubectl_file_documents.prometheus-ingress.manifests
    yaml_body = each.value

    depends_on = [helm_release.kube-prometheus]
}


data "kubectl_file_documents" "portfolio" {
    content = file("portfolio.yaml")
}

resource "helm_release" "prometheus-nginx-exporter" {
  name       = "prometheus-nginx-exporter"
  namespace  = "monitoring"
  version    = var.kube-version
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus-nginx-exporter"

  depends_on = [resource.kubernetes_namespace.monitoring, resource.kubectl_manifest.kube-deployment-socks-ingress]
}