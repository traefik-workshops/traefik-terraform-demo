resource "argocd_application" "traefik_grafana" {
  metadata {
    name      = "traefik-grafana"
    namespace = "argocd"
  }

  cascade  = true
  wait     = true
  validate = true

  spec {
    destination {
      server    = "https://kubernetes.default.svc"
      namespace = "traefik-observability"
    }

    sync_policy {
      automated {
        prune       = true
        self_heal   = true
        allow_empty = true
      }
      sync_options = [
        "CreateNamespace=true"
      ]
    }

    source {
      repo_url        = "https://grafana.github.io/helm-charts"
      chart           = "grafana"
      target_revision = "8.11.4"
      helm {
        release_name = "traefik-grafana"
        values = yamlencode({
          adminPassword = var.admin_password
          datasources = {
            "datasources.yaml" = {
              apiVersion = 1
              datasources = [
                {
                  name = "Prometheus"
                  type = "prometheus"
                  url = "http://traefik-prometheus-server:80"
                  access = "proxy"
                  isDefault = true
                },
                {
                  name = "Tempo"
                  type = "tempo"
                  url = "http://traefik-tempo:3100"
                  access = "proxy"
                  isDefault = false
                },
                {
                  name = "Loki"
                  type = "loki"
                  url = "http://traefik-loki:3100"
                  access = "proxy"
                  isDefault = false
                }
              ]
            }
          }

          dashboardProviders = {
            "dashboardproviders.yaml" = {
              apiVersion = 1
              providers = [
                {
                  name = "Hub API Management Dashboards"
                  orgId = "1"
                  folder = "Hub API Management"
                  type = "file"
                  updateIntervalSeconds = 10
                  options = {
                    path = "/dashboards/hub"
                    foldersFromFilesStructure = false
                  }
                }
              ]
            }
          }

          extraConfigmapMounts = [
            {
              name = "grafana-hub-api-management"
              mountPath = "/dashboards/hub/api-management.json"
              subPath = "api-management.json"
              configMap = "grafana-dashboards"
              readOnly = true
            },
            {
              name = "grafana-hub-api"
              mountPath = "/dashboards/hub/api.json"
              subPath = "api.json"
              configMap = "grafana-dashboards"
              readOnly = true
            },
            {
              name = "grafana-hub-dashboard"
              mountPath = "/dashboards/hub/hub-dashboard.json"
              subPath = "hub-dashboard.json"
              configMap = "grafana-dashboards"
              readOnly = true
            },
            {
              name = "grafana-hub-users"
              mountPath = "/dashboards/hub/users.json"
              subPath = "users.json"
              configMap = "grafana-dashboards"
              readOnly = true
            }
          ]
        })
      }
    }
  }

  depends_on = [kubernetes_config_map.grafana_dashboards]
}


resource "kubernetes_ingress_v1" "grafana-traefik" {
  metadata {
    name = "grafana"
    namespace = "traefik-observability"
  }

  spec {
    rule {
      host = "grafana.traefik"
      http {
        path {
          path = "/"
          path_type = "Exact"
          backend {
            service {
              name = "traefik-grafana"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }

  depends_on = [argocd_application.traefik_grafana]
}