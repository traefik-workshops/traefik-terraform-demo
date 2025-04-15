resource "k3d_cluster" "traefik_demo" {
  name    = "traefik-demo"
  # See https://k3d.io/v5.8.3/usage/configfile/#config-options
  k3d_config = <<EOF
apiVersion: k3d.io/v1alpha5
kind: Simple
metadata:
  name: traefik-demo
servers: 1
ports:
  - port: 8000:80
    nodeFilters:
      - loadbalancer
  - port: 8443:443
    nodeFilters:
      - loadbalancer
  - port: 8080:8080
    nodeFilters:
      - loadbalancer
options:
  k3s:
    extraArgs:
      - arg: "--disable=traefik"
        nodeFilters:
          - "server:*"
EOF
}

output "host" {
  description = "K3D cluster host"
  value = k3d_cluster.traefik_demo.host
}

output "client_certificate" {
  description = "K3D cluster client certificate"
  value = base64decode(k3d_cluster.traefik_demo.client_certificate)
}

output "client_key" {
  description = "K3D cluster client key"
  value = base64decode(k3d_cluster.traefik_demo.client_key)
}

output "cluster_ca_certificate" {
  description = "K3D cluster CA certificate"
  value = base64decode(k3d_cluster.traefik_demo.cluster_ca_certificate)
}
