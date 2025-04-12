resource "kubernetes_config_map" "grafana_dashboards" {
  metadata {
    name      = "grafana-dashboards"
    namespace = "traefik-observability"
  }

  data = {
    "api-management.json" = "${file("${path.module}/api-management.json")}"
    "api.json"            = "${file("${path.module}/api.json")}"
    "hub-dashboard.json"  = "${file("${path.module}/hub-dashboard.json")}"
    "users.json"          = "${file("${path.module}/users.json")}"
    "control-plane.json"  = "${file("${path.module}/control-plane.json")}"
  }
}
