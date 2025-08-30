variable "mtu" {
  description = "CP MTU policy."
  type        = number
  default     = 9000

  validation {
    condition     = var.mtu >= 576 && var.mtu <= 9216
    error_message = "Control Plane MTU must be between 576 and 9216."
  }
}

variable "apic_mtu_apply" {
  description = "APIC MTU apply policy. Set to null to omit the attribute for older APIC versions."
  type        = bool
  default     = null
}

