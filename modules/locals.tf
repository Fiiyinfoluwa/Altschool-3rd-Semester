# Define Local Values in Terraform
locals {
  owners           = var.owner
  environment      = var.environment
  name             = "${var.owner}-${var.environment}"
  eks_cluster_name = "${local.name}-${var.cluster_name}"

  # Group owners and environment into common_tags
  common_tags = {
    owners      = var.owner
    environment = var.environment
  }
}