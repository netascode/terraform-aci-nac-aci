variable "admin_state" {
  description = "Atomic Counter Administrative state."
  type        = bool
}

variable "mode" {
  description = "Atomic Counter Mode. Valid values are `trail` or `path`"
  type        = string
  default     = "trail"

  validation {
    condition     = contains(["trail", "path"], var.mode)
    error_message = "Valid values are `trail` or `path`."
  }
}

