resource "argocd_application" "traefik_loki_stack" {
  metadata {
    name      = "traefik-loki-stack"
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
      chart           = "loki-stack"
      target_revision = "2.10.2"
      helm {
        release_name = "traefik-loki-stack"
      }
    }
  }
}
