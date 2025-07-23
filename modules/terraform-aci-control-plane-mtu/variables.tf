variable "control_plane_mtu" {
  description = "CP MTU policy."
  type        = number
  default     = 9000

  validation {
    condition     = var.control_plane_mtu >= 576 && var.control_plane_mtu <= 9216
    error_message = "CPMtu policy must be between 576 and 9216."
  }
}

variable "apic_mtu_apply" {
  description = "APIC MTU apply policy"
  type        = bool
  default     = "false"
}

