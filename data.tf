


data "kubectl_file_documents" "prometheus-ingress" {
    content = file("prometheus.yaml")
}

data "kubectl_file_documents" "portfolio" {
    content = file("portfolio.yaml")    
}

data "kubectl_file_documents" "portfolio-ingress" {
    content = file("portfolio-ingress.yaml")
}

data "kubectl_file_documents" "docs" {
    content = file("microservices.yaml")    
}

data "kubectl_file_documents" "ingress" {
    content = file("sockshop-ingress.yaml")
}
