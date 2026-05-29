terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.27.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "3.0.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "3.1.1"
    }
    argocd = {
      source  = "argoproj-labs/argocd"
      version = "7.0.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.3"
    }
  }
}

provider "aws" {
  # Configuration options
  region = var.aws_region
}

provider "kubernetes" {
  host                   = module.eks_cluster.eks_cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks_cluster.eks_certificate_authority)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", module.eks_cluster.eks_cluster_name]
    command     = "aws"
  }
}

provider "helm" {
  kubernetes = {
    host                   = module.eks_cluster.eks_cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks_cluster.eks_certificate_authority)
    exec = {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", module.eks_cluster.eks_cluster_name]
      command     = "aws"
    }
  }
}

locals {
  argocd_server_addr_raw = replace(replace(var.argocd_server_addr, "https://", ""), "http://", "")
  argocd_server_addr     = can(regex(":[0-9]+$", local.argocd_server_addr_raw)) ? local.argocd_server_addr_raw : "${local.argocd_server_addr_raw}:443"
  # Avoid DNS/provider init failures when ArgoCD apps management is disabled (e.g. during destroy).
  argocd_server_addr_effective = var.enable_argocd_apps ? local.argocd_server_addr : "127.0.0.1:443"
  argocd_auth_token_effective  = var.enable_argocd_apps ? var.argocd_auth_token : "disabled"
}

provider "argocd" {
  server_addr = local.argocd_server_addr_effective
  auth_token  = local.argocd_auth_token_effective
  insecure    = var.argocd_insecure
}
