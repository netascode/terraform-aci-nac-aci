variable "config_passphrase" {
  description = "Config passphrase."
  type        = string
  sensitive   = true

  validation {
    condition     = can(regex("^.{16,32}$", var.config_passphrase))
    error_message = "Allowed characters: any. Minimum characters: 16. Maximum characters: 32."
  }
}
