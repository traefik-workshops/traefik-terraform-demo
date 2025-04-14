variable "enable_entraid" {
  description = "Enable Entraid security module"
  type        = bool
  default     = false
}

variable "enable_keycloak" {
  description = "Enable Keycloak security module"
  type        = bool
  default     = false
}

variable "users" {
  description = "List of users to create in the security module"
  type        = list(string)
  default     = ["admin", "maintainer", "developer", "support"]
}
