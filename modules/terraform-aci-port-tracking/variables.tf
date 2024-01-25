variable "admin_state" {
  description = "Admin state."
  type        = bool
  default     = false
}

variable "delay" {
  description = "Delay. Minimum value: 1. Maximum value: 300."
  type        = number
  default     = 120

  validation {
    condition     = var.delay >= 1 && var.delay <= 300
    error_message = "Minimum value: 1. Maximum value: 300."
  }
}

variable "min_links" {
  description = "Minimum links. Minimum value: 0. Maximum value: 48."
  type        = number
  default     = 0

  validation {
    condition     = var.min_links >= 0 && var.min_links <= 48
    error_message = "Minimum value: 0. Maximum value: 48."
  }
}

variable "include_apic" {
  description = "Include APIC ports."
  type        = bool
  default     = null
}
