variable "owner" {
  description = "Business Division"
  type        = string
  default     = "fiiyinfoluwa"
}


# Environment Variable
variable "environment" {
  description = "Environment Variable used as a prefix"
  type        = string
  default     = "stag"
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "vpc_cidr_block" {
  type    = string
  default = "10.5.0.0/16"
}

variable "public_subnets" {
  type = map(any)
  default = {
    "eks-public-1" = {
      name       = "eksPublic1"
      az         = "us-east-1a"
      cidr_block = "10.5.1.0/24"
      key        = "eksPublic1"
    },

    "eks-public-2" = {
      name       = "eksPublic2"
      az         = "us-east-1b"
      cidr_block = "10.5.2.0/24"
      key        = "eksPublic2"
    }
  }
}

variable "kube-version" {
  default = "36.2.0"
}

variable "private_subnets" {
  type = map(any)
  default = {
    "eks-private-1" = {
      name       = "eksPrivate1"
      az         = "us-east-1a"
      cidr_block = "10.5.3.0/24"
      key        = "eksPrivate1"
    },

    "eks-private-2" = {
      name       = "eksPrivate2"
      az         = "us-east-1b"
      cidr_block = "10.5.4.0/24"
      key        = "eksPrivate2"
    }
  }
}

variable "eks_sg" {
  type = map(any)
  default = {
    name           = "eks_sg"
    description    = "security group for eks cluster"
    eks_from_port  = 0
    eks_to_port    = 65535
  }
}

variable "cluster_name" {
  default = "my-cluster"
}

variable "eks_cidr_block" {
  default = ["0.0.0.0/0"]
}

variable "tags" {
  type = map(any)
  default = {
    vpc              = "vpc"
    internet_gateway = "igw"
    nat_gateway      = "nat-gw"
    publicRT         = "publicRT"
    privateRT        = "privateRT"
    elastic_ip       = "eip"
    sg               = "sg"
  }
}




