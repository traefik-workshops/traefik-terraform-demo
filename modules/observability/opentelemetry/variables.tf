variable "newrelic_license_key" {
  type        = string
  description = "New Relic license key"
}

variable "enable_loki" {
  type        = bool
  description = "Enable Grafana Loki observability module"
  default     = false
}

variable "enable_tempo" {
  type        = bool
  description = "Enable Grafana Tempo observability module"
  default     = false
}

variable "enable_new_relic" {
  type        = bool
  description = "Enable New Relic observability module"
  default     = false
}