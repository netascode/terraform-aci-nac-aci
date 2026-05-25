variable "name" {
  description = "MCP policy name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.name))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "admin_state" {
  description = "Admin state."
  type        = bool
  default     = true
}

variable "per_vlan_mcp" {
  description = "Per-VLAN MCP PDU transmission (`mcpPduPerVlan`)."
  type        = bool
  default     = true
}

variable "strict_mode" {
  description = "MCP strict mode (`mcpMode`). When `true`, `max_vlans` is capped at 256."
  type        = bool
  default     = false
}

variable "max_vlans" {
  description = "Max VLAN counter for per-VLAN PDU bursts. Minimum value: 1. Maximum value: 2000."
  type        = number
  default     = 256

  validation {
    condition     = var.max_vlans >= 1 && var.max_vlans <= 2000
    error_message = "Minimum value: 1. Maximum value: 2000."
  }
}

variable "grace_period" {
  description = "MCP strict-mode grace period in seconds. Minimum value: 0. Maximum value: 300."
  type        = number
  default     = 3

  validation {
    condition     = var.grace_period >= 0 && var.grace_period <= 300
    error_message = "Minimum value: 0. Maximum value: 300."
  }
}

variable "grace_period_msec" {
  description = "MCP strict-mode grace period in milliseconds. Minimum value: 0. Maximum value: 999."
  type        = number
  default     = 0

  validation {
    condition     = var.grace_period_msec >= 0 && var.grace_period_msec <= 999
    error_message = "Minimum value: 0. Maximum value: 999."
  }
}
