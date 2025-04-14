resource "argocd_application" "traefik_prometheus" {
  metadata {
    name      = "traefik-prometheus"
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
      repo_url        = "https://prometheus-community.github.io/helm-charts"
      chart           = "prometheus"
      target_revision = "v27.8.0"
      helm {
        release_name = "traefik-prometheus"
      }
    }
  }
}

resource "kubernetes_ingress_v1" "prometheus-traefik" {
  metadata {
    name = "prometheus"
    namespace = "traefik-observability"
    annotations = {
      "traefik.ingress.kubernetes.io/router.entrypoints" = "traefik"
    }
  }

  spec {
    rule {
      host = "prometheus.traefik"
      http {
        path {
          path = "/"
          path_type = "Prefix"
          backend {
            service {
              name = "traefik-prometheus-server"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }

  depends_on = [argocd_application.traefik_prometheus]
}
