# Install Traefik using ArgoCD
resource "argocd_application" "traefik" {
  metadata {
    name      = "traefik"
    namespace = "argocd"
  }

  cascade  = true
  wait     = true
  validate = true

  spec {
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

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = "traefik"
    }

    source {
      repo_url        = "https://traefik.github.io/charts"
      chart           = "traefik"
      target_revision = "35.0.0"
      
      helm {
        release_name = "traefik"
        values = yamlencode({
          hub = {
            token = var.enable_api_gateway || var.enable_api_management ? "traefik-hub-license" : ""
            apimanagement = {
              enabled = var.enable_api_management
            }
            redis = var.enable_api_management ? {
              endpoints = "redis-master.traefik.svc:6379"
              password = "topsecretpassword"
            } : {}
          }

          logs = {
            general = {
              level = var.log_level
            }
          }

          image = var.enable_api_gateway || var.enable_api_management ? {
            registry = "ghcr.io"
            repository = "traefik/traefik-hub"
            tag = "v3.15.0"
          } : {}

          providers = {
            kubernetesCRD = {
              allowCrossNamespace = true
              allowExternalNameServices = true
            }
            kubernetesIngress = {
              allowExternalNameServices = true
            }
          }

          metrics = {
            otlp = {
            enabled = true
              http = {
                enabled = true
                endpoint = "http://prometheus.monitoring:9090/api/v1/otlp/v1/metrics"
                tls = {
                  insecureSkipVerify = true
                }
              }
            }
          }

          tracing = {
            otlp = {
              enabled = true
              http = {
                enabled = true
                endpoint = "http://zipkin.zipkin.svc.cluster.local:9411/api/v2/spans"
                tls = {
                  insecureSkipVerify = true
                }
              }
            }
          }
        })
      }
    }
  }

  depends_on = [ helm_release.argocd, argocd_application.redis ]
}


# Install Redis using ArgoCD
resource "argocd_application" "redis" {
  metadata {
    name      = "redis"
    namespace = "argocd"
  }

  cascade  = true
  wait     = true
  validate = true

  spec {
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

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = "traefik"
    }

    source {
      repo_url        = "https://charts.bitnami.com/bitnami"
      chart           = "redis"
      target_revision = "19.6.4"
      
      helm {
        release_name = "redis"
        values = yamlencode({
          auth = {
            password = "topsecretpassword"
          }

          replica = {
            replicaCount = 1
          }
        })
      }
    }
  }

  depends_on = [ helm_release.argocd ]
  count = var.enable_api_management ? 1 : 0
}
