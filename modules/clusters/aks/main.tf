resource "azurerm_resource_group" "traefik_demo" {
  name     = "traefik-${var.cluster_location}"
  location = var.cluster_location
}

resource "azurerm_kubernetes_cluster" "traefik_demo" {
  name                = azurerm_resource_group.traefik_demo.name
  location            = azurerm_resource_group.traefik_demo.location
  kubernetes_version  = var.aks_version
  resource_group_name = azurerm_resource_group.traefik_demo.name
  dns_prefix          = replace(azurerm_resource_group.traefik_demo.name, "_", "-")

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = var.cluster_machine_type
  }

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "traefik_demo" {
  name                  = substr(replace(azurerm_resource_group.traefik_demo.name, "-", ""), 0, 12)
  kubernetes_cluster_id = azurerm_kubernetes_cluster.traefik_demo.id
  vm_size               = var.cluster_machine_type
  node_count            = var.cluster_node_count
}