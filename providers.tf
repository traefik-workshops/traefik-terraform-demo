locals {
  host                    = var.cluster == "k3d" ? module.k3d[0].host :                   module.aks[0].host
  client_certificate      = var.cluster == "k3d" ? module.k3d[0].client_certificate :     module.aks[0].client_certificate
  client_key              = var.cluster == "k3d" ? module.k3d[0].client_key :             module.aks[0].client_key
  cluster_ca_certificate  = var.cluster == "k3d" ? module.k3d[0].cluster_ca_certificate : module.aks[0].cluster_ca_certificate
}

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

provider "azurerm" {
  features {}
  subscription_id = var.azure_subscription_id
}

provider "helm" {
  kubernetes {
    host                   = local.host
    client_certificate     = local.client_certificate
    client_key             = local.client_key
    cluster_ca_certificate = local.cluster_ca_certificate
  }
}

provider "kubernetes" {
  host                   = local.host
  client_certificate     = local.client_certificate
  client_key             = local.client_key
  cluster_ca_certificate = local.cluster_ca_certificate
}

provider "argocd" {
  port_forward = true
  
  username = "admin"
  password = local.password
  
  kubernetes {
    host                   = local.host
    client_certificate     = local.client_certificate
    client_key             = local.client_key
    cluster_ca_certificate = local.cluster_ca_certificate
  }
}