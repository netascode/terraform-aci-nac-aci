variable "cp_mtu" {
  description = "Control plane MTU. Minimum value: `576`. Maximum value: `9216`."
  type        = number
  default     = 9000

  validation {
    condition     = var.cp_mtu >= 576 && var.cp_mtu <= 9216
    error_message = "Minimum value: `576`. Maximum value: `9216`."
  }
}
