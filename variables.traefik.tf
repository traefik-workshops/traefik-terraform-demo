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