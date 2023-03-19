terraform {
	backend "remote" {
		organization = "fiiyinfoluwa"
		workspaces {
			name = "exam-cluster1" 
		}
	}
}

terraform {
  required_providers {
    kubectl = {
      source = "gavinbunney/kubectl"
      version = "1.14.0"
    }
    helm = {
      source = "hashicorp/helm"
      #version = "2.5.1"
      version = "~> 2.5"
    }
    namedotcom = {
      source  = "lexfrei/namedotcom"
      version = "1.2.5"
    }
    http = {
      source = "hashicorp/http"
      #version = "2.1.0"
      version = "~> 2.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.11"
    }
  }
}

provider "aws" {
    access_key = var.access_key
    secret_key = var.secret_key
    region     = "us-east-1"
}

module "provison-deploy" {
    access_key = var.access_key
    secret_key = var.secret_key
    source = "./modules"
}

resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }

  depends_on = [module.provison-deploy]
}

data "kubectl_path_documents" "service-monitor" {
    pattern = "./sockshop-servicemonitor/*.yaml"

  depends_on = [kubernetes_namespace.monitoring]
}

resource "kubectl_manifest" "service-monitor" {
    for_each  = toset(data.kubectl_path_documents.docs.documents)
    yaml_body = each.value
}





