output "tenant_id" {
  sensitive = true
  description = "The tenant ID of the Azure AD directory"
  value       = var.enable_entraid ? module.security-entraid[0].tenant_id : null
}

output "client_id" {
  sensitive   = true
  description = "The client ID for the application"
  value       = var.enable_entraid ? module.security-entraid[0].client_id : null
}

output "client_secret" {
  sensitive   = true
  description = "The client secret for the application"
  value       = var.enable_entraid ? module.security-entraid[0].client_secret : null
}

output "users" {
  description = "List of users created in the security module"
  value       = var.enable_entraid ? module.security-entraid[0].users : []
}