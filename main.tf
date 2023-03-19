terraform {
	backend "remote" {
		organization = "fiiyinfoluwa"
		workspaces {
			name = "exam-cluster1" 
		}
	}
}


module "provison-deploy" {
    access_key = var.access_key
    secret_key = var.secret_key
    source = "./modules"
}

data "kubectl_path_documents" "docs" {
    pattern = "./manifests-monitoring/*.yaml"

    depends_on = [
        module.provison-deploy
    ]
}

resource "kubectl_manifest" "monitoring" {
    for_each  = toset(data.kubectl_path_documents.docs.documents)
    yaml_body = each.value
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


