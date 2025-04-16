variable "users" {
  type        = list(string)
  description = "EntraID users to be created"
  default     = ["admin", "maintainer", "developer", "support"]
}
