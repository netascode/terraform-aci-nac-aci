variable "name" {
  description = "Fabric L2 MTU custom policy name"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.name)) && var.name != "default"
    error_message = "Name `default` is not allowed. Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "port_mtu_size" {
  description = "L2 MTU. Minimum value: `576`. Maximum value: `9216`."
  type        = number
  default     = 9000

  validation {
    condition     = var.port_mtu_size >= 576 && var.port_mtu_size <= 9216
    error_message = " Minimum value: `576`. Maximum value: `9216`."
  }
}
