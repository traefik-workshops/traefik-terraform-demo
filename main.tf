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
                number = 80
              }
            }
          }
        }
      }
    }
    rule {
      host = "argocd.traefik.localhost"
      http {
        path {
          path = "/"
          path_type = "Prefix"
          backend {
            service {
              name = "argocd-server"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }

  depends_on = [helm_release.argocd, argocd_application.traefik]
}

# Observability modules
module "observability-opentelemetry" {
  source = "./modules/observability/opentelemetry"

  newrelic_license_key = var.newrelic_license_key

  enable_loki      = var.enable_loki
  enable_tempo     = var.enable_tempo
  enable_new_relic = var.enable_new_relic

  depends_on = [helm_release.argocd]
}

module "observability-grafana-loki" {
  source = "./modules/observability/grafana-loki"

  count      = var.enable_loki ? 1 : 0
  depends_on = [module.observability-opentelemetry]
}

module "observability-grafana-tempo" {
  source = "./modules/observability/grafana-tempo"

  count      = var.enable_tempo ? 1 : 0
  depends_on = [module.observability-opentelemetry]
}

module "observability-prometheus" {
  source = "./modules/observability/prometheus"

  count      = var.enable_prometheus ? 1 : 0
  depends_on = [module.observability-opentelemetry]
}

module "observability-grafana" {
  source = "./modules/observability/grafana"

  admin_password = local.password

  count      = var.enable_grafana ? 1 : 0
  depends_on = [module.observability-opentelemetry]
}

# Security modules
module "security-keycloak" {
  source = "./modules/security/keycloak"

  users = var.users

  count = var.enable_keycloak ? 1 : 0

  depends_on = [helm_release.argocd]
}