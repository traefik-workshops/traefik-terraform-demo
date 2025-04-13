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
    name = "controller.readinessProbe.initialDelaySeconds"
    value = "30"
  }

  set {
    name  = "configs.secret.argocdServerAdminPassword"
    value = "$2a$10$Pgp0gJC3saX42x0b7JQOB./5UVe4FXvN/5j0dXL4J76lTgiwg9NK2" # topsecretpassword
  }

  set {
    name = "crds.keep"
    value = "false"
  }
}

# Observability modules
module "observability-opentelemetry" {
  source = "./modules/observability/opentelemetry"
}

module "observability-grafana-loki" {
  source = "./modules/observability/grafana-loki"
  
  count = var.enable_loki ? 1 : 0
  depends_on = [ module.observability-opentelemetry ]
}

module "observability-grafana-tempo" {
  source = "./modules/observability/grafana-tempo"
  
  count = var.enable_tempo ? 1 : 0
  depends_on = [ module.observability-opentelemetry ]
}

module "observability-prometheus" {
  source = "./modules/observability/prometheus"
  
  count = var.enable_prometheus ? 1 : 0
  depends_on = [ module.observability-opentelemetry ]
}

module "observability-grafana" {
  source = "./modules/observability/grafana"

  admin_password = local.password
  
  count = var.enable_grafana ? 1 : 0
  depends_on = [ module.observability-opentelemetry ]
}

module "observability-new-relic" {
  source = "./modules/observability/new-relic"
  
  newrelic_license_key = var.newrelic_license_key
  
  count = var.enable_new_relic ? 1 : 0
  depends_on = [ module.observability-opentelemetry ]
}
  