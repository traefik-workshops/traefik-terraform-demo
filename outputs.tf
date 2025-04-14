data "kubernetes_service" "traefik" {
  metadata {
    name = "traefik"
    namespace = "traefik"
  }

  depends_on = [argocd_application.traefik]
}

output "traefik_ip" {
  description = "The IP address of the Traefik ingress controller"
  value       = data.kubernetes_service.traefik.status.0.load_balancer.0.ingress.0.ip
}

output "exposed_urls" {
  description = "The URL of the exposed services"
  value = [
    "http://dashboard.traefik:8080",
    "http://prometheus.traefik:8080",
    "http://grafana.traefik:8080",
    "http://keycloak.traefik:8080",
    "http://httpbin.traefik",
    "http://gateway.traefik",
  ]
}
