resource "argocd_application" "traefik_newrelic" {
  metadata {
    name      = "traefik-newrelic"
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
      repo_url        = "https://helm-charts.newrelic.com"
      chart           = "nri-bundle"
      target_revision = "5.0.119"
      helm {
        release_name = "traefik-newrelic"
        values = yamlencode({
          global = {
            licenseKey = var.newrelic_license_key
            cluster   = "traefik-demo"
          }

          kube-state-metrics = {
            enabled = true
          }

          nri-kube-events = {
            enabled = true
          }

          newrelic-logging = {
            enabled = true
          }

          newrelic-prometheus-agent = {
            enabled = true
          }

          k8s-agents-operator = {
            enabled = true
          }
        })
      }
    }
  }
}
