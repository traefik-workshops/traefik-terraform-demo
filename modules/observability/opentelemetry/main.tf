resource "argocd_application" "traefik_opentelemetry" {
  metadata {
    name      = "traefik-opentelemetry"
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
      repo_url        = "https://open-telemetry.github.io/opentelemetry-helm-charts"
      chart           = "opentelemetry-collector"
      target_revision = "0.120.2"
      helm {
        release_name = "traefik-opentelemetry"
        values = yamlencode({
          mode = "deployment"
          image = {
            repository = "otel/opentelemetry-collector-k8s"
          }
          config = { 
            receivers = {
              "otlp" = {
                "protocols" = {
                  "http" = {
                    endpoint = "0.0.0.0:4318"
                  }
                }
              }
            }
            processors = {
              batch = {}
            }
            exporters = {
              "otlphttp/loki" = {
                endpoint = "http://traefik-loki.traefik-observability:3100/loki/api/v1/push"
                tls = {
                  insecure = true
                }
              },
              "otlphttp/tempo" = {
                endpoint = "http://traefik-tempo.traefik-observability:4318"
                tls = {
                  insecure = true
                }
              }
            }
            service = { 
              pipelines = {
                logs = {
                  receivers = ["otlp"],
                  processors = ["batch"],
                  exporters = ["otlphttp/loki"]
                },
                metrics = {
                  receivers = ["otlp"],
                  processors = ["batch"]
                },
                traces = {
                  receivers = ["otlp"],
                  processors = ["batch"],
                  exporters = ["otlphttp/tempo"]
                }
              }
            }
          }
        })
      }
    }
  }
}