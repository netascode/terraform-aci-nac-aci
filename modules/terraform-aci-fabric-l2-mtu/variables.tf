variable "l2_port_mtu" {
  description = "Fabric L2 MTU. Minimum value: `576`. Maximum value: `9216`."
  type        = number
  default     = 9000

  validation {
    condition     = var.l2_port_mtu >= 576 && var.l2_port_mtu <= 9216
    error_message = " Minimum value: `576`. Maximum value: `9216`."
  }
}
