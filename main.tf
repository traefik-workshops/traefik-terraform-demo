locals {
  password = "topsecretpassword"
}

# Install Redis Cluster when API Management is enabled
resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = "7.8.23"
  namespace        = "argocd"
  create_namespace = true

  set {
    name  = "controller.readinessProbe.initialDelaySeconds"
    value = "30"
  }

  set {
    name  = "configs.secret.argocdServerAdminPassword"
    value = "$2a$10$Pgp0gJC3saX42x0b7JQOB./5UVe4FXvN/5j0dXL4J76lTgiwg9NK2" # topsecretpassword
  }

  set {
    name  = "crds.keep"
    value = "false"
  }
}