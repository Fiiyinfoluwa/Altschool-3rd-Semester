# terraform {
#   required_providers {
#     kubectl = {
#       source  = "gavinbunney/kubectl"
#     }
#   }
# }

# provider "kubectl" {
#   host                   = data.terraform_remote_state.eks.output.endpoint
#   cluster_ca_certificate = base64decode(data.terraform_remote_state.eks.output.certificate_authority_data)
#   token                  = data.aws_eks_cluster_auth.cluster-auth.token
#   load_config_file       = false
# }

# data "terraform_remote_state" "eks" {
#   backend = "remote"
#   config = {
#     organization = "fiiyinfoluwa"

#     workspaces = {
#       name = "exam-cluster1"
#     }
#   }
# }
# data "aws_eks_cluster_auth" "cluster-auth" {
#   name = "my-cluster"

#   depends_on = [data.terraform_remote_state.eks]
# }

# data "aws_eks_cluster" "eks_cluster" {
#   name = "my-cluster"
# }

# data "kubectl_path_documents" "docs" {
#     pattern = "./manifests-monitoring/*.yaml"
# }

# resource "kubectl_manifest" "monitoring" {
#     for_each  = toset(data.kubectl_path_documents.docs.documents)
#     yaml_body = each.value
# }