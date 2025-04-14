variable "cluster" {
  type        = string
  description = "Cluster to use for the deployment"
  validation {
    condition     = contains(["k3d", "aks"], var.cluster)
    error_message = "Cluster must be 'k3d' or 'aks'"
  }
}

variable "enable_api_gateway" {
  description = "Enable Traefik Hub API Gateway features"
  type        = bool
  default     = false
}

variable "enable_api_management" {
  description = "Enable Traefik Hub API Management features (includes API Gateway features)"
  type        = bool
  default     = false
}

variable "log_level" {
  description = "Log level for Traefik Hub"
  type        = string
  default     = "INFO"
}

variable "azure_subscription_id" {
  type        = string
  description = "Azure subscription ID to use for the deployment"
  default     = ""

  validation {
    condition     = (var.cluster == "aks" && var.enable_entraid == false)|| var.azure_subscription_id != ""
    error_message = "Azure subscription ID is required when enable_entraid is true"
  }
}