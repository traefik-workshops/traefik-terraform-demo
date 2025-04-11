module "aks" {
  source = "./aks"
  
  subscription_id       = var.subscription_id
  cluster_location      = var.cluster_location
  cluster_machine_type  = var.cluster_machine_type
  cluster_node_count    = var.cluster_node_count
  aks_version           = var.aks_version

  count = var.aks_enabled ? 1 : 0
}

module "entraid" {
  source = "./entraid"

  users = var.entraid_users
  
  count = var.entraid_enabled ? 1 : 0
}