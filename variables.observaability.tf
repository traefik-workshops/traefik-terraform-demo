variable "enable_loki" {
  description = "Enable Grafana Loki observability module"
  type        = bool
  default     = false
}

variable "enable_tempo" {
  description = "Enable Grafana Tempo observability module"
  type        = bool
  default     = false
}

variable "enable_prometheus" {
  description = "Enable Prometheus observability module"
  type        = bool
  default     = false
}

variable "enable_grafana" {
  description = "Enable Grafana observability module"
  type        = bool
  default     = false
}

variable "enable_new_relic" {
  type        = bool
  description = "Enable New Relic observability"
  default     = false
}

variable "newrelic_license_key" {
  type        = string
  description = "New Relic license key"
  sensitive   = true
  validation {
    condition     = var.enable_new_relic == false || var.newrelic_license_key != ""
    error_message = "New Relic license key is required when enable_new_relic is true"
  }
}