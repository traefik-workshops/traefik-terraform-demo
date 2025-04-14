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

resource "kubernetes_ingress_v1" "argocd-traefik" {
  metadata {
    name = "argocd"
    namespace = "argocd"
    annotations = {
      "traefik.ingress.kubernetes.io/router.entrypoints" = "traefik"
    }
  }

  spec {
    rule {
      host = "argocd.traefik"
      http {
        path {
          path = "/"
          path_type = "Prefix"
          backend {
            service {
              name = "argocd-server"
              port {
                number = 443
              }
            }
          }
        }
      }
    }
  }

  depends_on = [helm_release.argocd, argocd_application.traefik]
}