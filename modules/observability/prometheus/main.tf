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

resource "kubernetes_manifest" "prometheus-traefik-httproute" {
  manifest = {
    apiVersion = "gateway.networking.k8s.io/v1"
    kind = "HTTPRoute"
    metadata = {
      name = "prometheus"
      namespace = "traefik-observability"
    }
    spec = {
      parentRefs = [{
        name = "traefik"
        sectionName = "traefik"
        kind = "Gateway"
      }]
      hostnames = ["prometheus.traefik"]
      rules = [{
        matches = [{
          path = {
            type = "PathPrefix"
            value = "/"
          }
        }]
        backendRefs = [{
          name = "traefik-prometheus-server"
          namespace = "traefik-observability"
          port = 80
        }]
      }]
    }
  }

  depends_on = [argocd_application.traefik_prometheus]
}
