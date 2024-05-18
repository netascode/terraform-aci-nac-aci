variable "name" {
  description = "LLDP interface policy name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.name))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "admin_rx_state" {
  description = "Administrative state receive."
  type        = bool
  default     = false
}

variable "admin_tx_state" {
  description = "Administrative state transmit."
  type        = bool
  default     = false
}
