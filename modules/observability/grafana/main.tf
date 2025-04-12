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
                  url = "http://traefik-loki-stack:3100"
                  access = "proxy"
                  isDefault = false
                }
              ]
            }
          }
        })
      }
    }
  }
}

