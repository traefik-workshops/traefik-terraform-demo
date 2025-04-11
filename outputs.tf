output "external_ip" {
  description = "External IP address of the Traefik LoadBalancer service"
  value       = data.kubernetes_service.traefik.status.0.load_balancer.0.ingress.0.ip
}

# Data source to get the Traefik service details
data "kubernetes_service" "traefik" {
  metadata {
    name      = "traefik"
    namespace = "traefik"
  }

  depends_on = [
    helm_release.traefik
  ]
}
