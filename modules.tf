# Cluster modules
module "k3d" {
  source = "./modules/clusters/k3d"

  count = var.cluster == "k3d" ? 1 : 0
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
}