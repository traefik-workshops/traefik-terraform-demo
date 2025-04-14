output "tenant_id" {
  sensitive = true
  description = "The tenant ID of the Azure AD directory"
  value       = module.entraid.tenant_id
}

output "client_id" {
  sensitive   = true
  description = "The client ID for the application"
  value       = module.entraid.application_client_id
}

output "client_secret" {
  sensitive   = true
  description = "The client secret for the application"
  value       = module.entraid.application_client_secret
}

output "users" {
  description = "List of users to create in the security module"
  value       = module.entraid.users
}