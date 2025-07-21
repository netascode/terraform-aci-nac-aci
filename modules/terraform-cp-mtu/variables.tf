variable "admin_state" {
  description = "Admin state."
  type        = bool
  default     = false
}

variable "CPMtu" {
  description = "CPU MTU policy."
  type        = number
  default     = 9000

  validation {
    condition     = var.CPMtu >= 576 && var.CPMtu <= 9216
    error_message = "CPMtu polcy must be between 1500 and 9216."
  }
}


variable "APICMtuApply" {
  description = "APIC MTU apply policy"
  type        = bool
  default     = "false"
}

