resource "kubectl_manifest" "cert_manager" {
  manifest = curl("https://github.com/jetstack/cert-manager/releases/download/v1.7.1/cert-manager.yaml")

}

data "kubectl_file_documents" "staging_issuer" {
  content = file("staging_issuer.yaml")
}

resource "kubectl_manifest" "staging_issuer" {
  for_each = data.kubectl_file_documents.staging_issuer.manifests
  yaml_body = each.value
}

data "kubectl_file_documents" "prod_issuer" {
  content = file("prod_issuer.yaml")
}

resource "kubectl_manifest" "prod_issuer" {
  for_each = data.kubectl_file_documents.prod_issuer.manifests
  yaml_body = each.value
}

data "kubectl_file_documents" "sockshop-staging" {
  content = file("sockshop-staging.yaml")
}

resource "kubectl_manifest" "sockshop-staging" {
  for_each = data.kubectl_file_documents.sockshop-staging.manifests
  yaml_body = each.value
}

data "kubectl_file_documents" "sockshop-prod" {
  content = file("sockshop-prod.yaml")
}

resource "kubectl_manifest" "sockshop-prod" {
  for_each = data.kubectl_file_documents.sockshop-prod.manifests
  yaml_body = each.value
}

data "kubectl_file_documents" "portfolio-staging" {
  content = file("portfolio-staging.yaml")
}

resource "kubectl_manifest" "portfolio-staging" {
  for_each = data.kubectl_file_documents.portfolio-staging.manifests
  yaml_body = each.value
}

data "kubectl_file_documents" "portfolio-prod" {
  content = file("portfolio-staging.yaml")
}

resource "kubectl_manifest" "portfolio-prod" {
  for_each = data.kubectl_file_documents.portfolio-prod.manifests
  yaml_body = each.value
}

data "kubectl_file_documents" "grafana-staging" {
  content = file("grafana-staging.yaml")
}

resource "kubectl_manifest" "grafana-staging" {
  for_each = data.kubectl_file_documents.grafana-staging.manifests
  yaml_body = each.value
}

data "kubectl_file_documents" "grafana-prod" {
  content = file("grafana-prod.yaml")
}

resource "kubectl_manifest" "grafana-prod" {
  for_each = data.kubectl_file_documents.grafana-prod.manifests
  yaml_body = each.value
}

data "kubectl_file_documents" "loki-staging" {
  content = file("grafana-staging.yaml")
}

resource "kubectl_manifest" "loki-staging" {
  for_each = data.kubectl_file_documents.loki-staging.manifests
  yaml_body = each.value
}

data "kubectl_file_documents" "loki-prod" {
  content = file("loki-prod.yaml")
}

resource "kubectl_manifest" "loki-prod" {
  for_each = data.kubectl_file_documents.loki-prod.manifests
  yaml_body = each.value
}