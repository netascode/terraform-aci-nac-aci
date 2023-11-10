variable "config_passphrase" {
  description = "Config passphrase."
  type        = string
  sensitive   = true

  validation {
    condition     = can(regex("^.{0,32}$", var.config_passphrase))
    error_message = "Maximum characters: 32."
  }
}
