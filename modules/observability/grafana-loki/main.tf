resource "argocd_application" "traefik_loki" {
  metadata {
    name      = "traefik-loki"
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
      chart           = "loki"
      target_revision = "6.29.0"
      helm {
        release_name = "traefik-loki"
        values = yamlencode({
          deploymentMode = "SingleBinary"
          
          singleBinary = {
            replicas = 1
          }
          loki = {
            auth_enabled = false
            commonConfig = {
              replication_factor = 1
            }
            useTestSchema = true
            storage = {
              type = "filesystem"
            }
          }

          lokiCanary = {
            enabled = false
          }

          test = {
            enabled = false
          }
  
          gateway = {
            enabled = false
          }
          write = {
            replicas = 0
          }
          read = {
            replicas = 0
          }
          backend = {
            replicas = 0
          }

          ruler = {
            enabled = false
          }

          resultsCache = {
            enabled = false
          }

          chunksCache = {
            enabled = false
          }
        })
      }
    }
  }
}
