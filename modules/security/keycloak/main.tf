resource "kubernetes_namespace" "traefik_security" {
  metadata {
    name = "traefik-security"
  }
}

resource "argocd_application" "traefik_keycloak" {
  metadata {
    name      = "traefik-keycloak"
    namespace = "argocd"
  }

  cascade  = true
  wait     = true
  validate = true

  spec {
    destination {
      server    = "https://kubernetes.default.svc"
      namespace = "traefik-security"
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
      repo_url        = "https://charts.bitnami.com/bitnami"
      chart           = "postgresql"
      target_revision = "15.5.18"
      
      helm {
        release_name = "traefik-keycloak-postgres"
        values = yamlencode({
          auth = {
            database = "keycloak-db"
            postgresPassword = "topsecretpassword"
          }
          primary = {
            persistentVolumeClaimRetentionPolicy = {
              whenDeleted = "Delete"
            }
          }
        })
      }
    }

    source {
      repo_url        = "https://github.com/keycloak/keycloak-k8s-resources.git"
      path            = "kubernetes"
      target_revision = "26.2.0"
    }
  }
}

resource "kubernetes_secret" "traefik_keycloak_db_secret" {
  metadata {
    name = "keycloak-db-secret"
    namespace = "traefik-security"
  }

  type = "Opaque"
  data = {
    username = "postgres"
    password = "topsecretpassword"
  }

  depends_on = [kubernetes_namespace.traefik_security]
}

resource "kubernetes_secret" "traefik_keycloak_secret" {
  metadata {
    name = "keycloak-secret"
    namespace = "traefik-security"
  }

  type = "Opaque"
  data = {
    username = "admin"
    password = "topsecretpassword"
  }

  depends_on = [kubernetes_namespace.traefik_security]
}

resource "kubectl_manifest" "keycloak_crd" {
  depends_on = [argocd_application.traefik_keycloak, kubernetes_secret.traefik_keycloak_db_secret]

  yaml_body = <<YAML
apiVersion: k8s.keycloak.org/v2alpha1
kind: Keycloak
metadata:
  name: keycloak
  namespace: traefik-security
spec:
  instances: 1
  bootstrapAdmin:
    user:
      secret: keycloak-secret
  db:
    vendor: postgres
    host: traefik-keycloak-postgres-postgresql.traefik-security.svc
    port: 5432
    database: keycloak-db
    usernameSecret:
      name: keycloak-db-secret
      key: username
    passwordSecret:
      name: keycloak-db-secret
      key: password
  http:
    httpEnabled: true
  hostname:
    strict: false
    strictBackchannel: false
  ingress:
    enabled: false
YAML
}

resource "kubernetes_ingress_v1" "keycloak-traefik" {
  metadata {
    name = "keycloak"
    namespace = "traefik-security"
    annotations = {
      "traefik.ingress.kubernetes.io/router.entrypoints" = "traefik"
    }
  }

  spec {
    rule {
      host = "keycloak.traefik"
      http {
        path {
          path = "/"
          path_type = "Prefix"
          backend {
            service {
              name = "keycloak-service"
              port {
                number = 8080
              }
            }
          }
        }
      }
    }
    rule {
      host = "keycloak.traefik.localhost"
      http {
        path {
          path = "/"
          path_type = "Prefix"
          backend {
            service {
              name = "keycloak-service"
              port {
                number = 8080
              }
            }
          }
        }
      }
    }
  }

  depends_on = [kubectl_manifest.keycloak_crd]
}