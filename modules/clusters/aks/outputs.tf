output "host" {
  description = "AKS cluster host"
  value = module.aks.kube_config.host
}

output "client_certificate" {
  description = "AKS cluster client certificate"
  value = base64decode(module.aks.kube_config.client_certificate)
}

output "client_key" {
  description = "AKS cluster client key"
  value = base64decode(module.aks.kube_config.client_key)
}

output "cluster_ca_certificate" {
  description = "AKS cluster CA certificate"
  value = base64decode(module.aks.kube_config.cluster_ca_certificate)
}

output "resource_group_name" {
  description = "Resource group name"
  value = module.aks.resource_group_name
}

output "cluster_name" {
  description = "Cluster name"
  value = module.aks.cluster_name
}