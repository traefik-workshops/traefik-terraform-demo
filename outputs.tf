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

output "treafik_dashboard_url" {
  description = "The URL of the Traefik dashboard"
  value       = "http://dashboard.traefik:8080"
}

output "treafik_prometheus_url" {
  description = "The URL of the Prometheus dashboard"
  value       = "http://prometheus.traefik:8080"
}

output "treafik_grafana_url" {
  description = "The URL of the Grafana dashboard"
  value       = "http://grafana.traefik:8080"
}

output "treafik_keycloak_url" {
  description = "The URL of the Keycloak dashboard"
  value       = "http://keycloak.traefik:8080"
}
