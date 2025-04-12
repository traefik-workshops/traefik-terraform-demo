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