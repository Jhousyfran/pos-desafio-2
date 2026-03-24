terraform {
  required_providers {
    argocd = {
      source  = "argoproj-labs/argocd"
      version = "7.0.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "3.0.1"
    }
  }
}
