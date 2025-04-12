resource "argocd_application" "traefik_tempo" {
  metadata {
    name      = "traefik-tempo"
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
      chart           = "tempo"
      target_revision = "1.20.0"
      helm {
        release_name = "traefik-tempo"
        values = yamlencode({
          tempo = {
            reporting_enabled = false
          }
          tempo_query = {
            enabled = true
          }
        })
      }
    }
  }
}
