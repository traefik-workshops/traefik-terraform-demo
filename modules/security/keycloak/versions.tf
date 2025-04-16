terraform {
  required_providers {
    argocd = {
      source  = "argoproj-labs/argocd"
      version = "7.5.2"
    }
    kubectl = {
      source = "gavinbunney/kubectl"
      version = "1.19.0"
    }
  }
}