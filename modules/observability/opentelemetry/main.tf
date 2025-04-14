locals {
  loki_exporter = var.enable_loki ? ["otlphttp/loki"] : []
  tempo_exporter = var.enable_tempo ? ["otlphttp/tempo"] : []
  newrelic_exporter = var.enable_new_relic ? ["otlphttp/nri"] : []
  
  log_exporters = concat(local.loki_exporter, local.newrelic_exporter)
  trace_exporters = concat(local.tempo_exporter, local.newrelic_exporter)
  metric_exporters = local.newrelic_exporter
}

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
                endpoint = "http://traefik-loki.traefik-observability:3100/otlp"
                tls = {
                  insecure = true
                }
              },
              "otlphttp/tempo" = {
                endpoint = "http://traefik-tempo.traefik-observability:4318"
                tls = {
                  insecure = true
                }
              },
              "otlphttp/nri" = {
                endpoint = "https://otlp.nr-data.net"
                headers = {
                  api-key = var.newrelic_license_key
                }
              }
            }
            service = { 
              pipelines = {
                logs = {
                  receivers = ["otlp"],
                  processors = ["batch"],
                  exporters = local.log_exporters
                },
                metrics = {
                  receivers = ["otlp"],
                  processors = ["batch"],
                  exporters = local.metric_exporters
                },
                traces = {
                  receivers = ["otlp"],
                  processors = ["batch"],
                  exporters = local.trace_exporters
                }
              }
            }
          }
        })
      }
    }
  }
}