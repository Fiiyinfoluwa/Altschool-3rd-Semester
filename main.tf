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
    region     = "us-east-1"
}

data "kubectl_path_documents" "service-monitor" {
    pattern = "./sockshop-servicemonitor/*.yaml"
}

resource "kubectl_manifest" "service-monitor" {
    for_each  = toset(data.kubectl_path_documents.service-monitor.documents)
    yaml_body = each.value
}

module "provison-deploy" {
    source = "./modules"
}








