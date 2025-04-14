terraform {
  required_providers {
    k3d = {
      source  = "SneakyBugs/k3d"
      version = "1.0.1"
    }
    argocd = {
      source  = "argoproj-labs/argocd"
      version = "7.5.2"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.25.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "3.2.0"
    }
  }
}
