terraform {
  required_providers {
    k3d = {
      source = "SneakyBugs/k3d"
      version = "1.0.1"
    }
    argocd = {
      source = "argoproj-labs/argocd"
      version = "7.5.2"
    }
  }
}

resource "k3d_cluster" "traefik_demo" {
  name    = "traefik-demo"
  # See https://k3d.io/v5.8.3/usage/configfile/#config-options
  k3d_config = <<EOF
apiVersion: k3d.io/v1alpha5
kind: Simple
metadata:
  name: traefik-demo
servers: 1
agents: 1
options:
  k3s:
    extraArgs:
      - arg: "--disable=traefik"
        nodeFilters:
          - "server:*"
EOF
}

provider "helm" {
  kubernetes {
    host                   = k3d_cluster.traefik_demo.host
    client_certificate     = base64decode(k3d_cluster.traefik_demo.client_certificate)
    client_key             = base64decode(k3d_cluster.traefik_demo.client_key)
    cluster_ca_certificate = base64decode(k3d_cluster.traefik_demo.cluster_ca_certificate)
  }
}

provider "kubernetes" {
  host                   = k3d_cluster.traefik_demo.host
  client_certificate     = base64decode(k3d_cluster.traefik_demo.client_certificate)
  client_key             = base64decode(k3d_cluster.traefik_demo.client_key)
  cluster_ca_certificate = base64decode(k3d_cluster.traefik_demo.cluster_ca_certificate)
}

provider "argocd" {
  port_forward = true
  
  username = "admin"
  password = local.password
  
  kubernetes {
    host                   = k3d_cluster.traefik_demo.host
    client_certificate     = base64decode(k3d_cluster.traefik_demo.client_certificate)
    client_key             = base64decode(k3d_cluster.traefik_demo.client_key)
    cluster_ca_certificate = base64decode(k3d_cluster.traefik_demo.cluster_ca_certificate)
  }
}
