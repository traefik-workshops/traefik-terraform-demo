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
      target_revision = "15.5.38"
      
      helm {
        release_name = "traefik-keycloak-postgres"
        values = yamlencode({
          postgresql = {
            database = "keycloak-db"
            postgresqlPassword = "topsecretpassword"
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
