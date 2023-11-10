variable "name" {
  description = "L2 interface policy name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.name))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "vlan_scope" {
  description = "VLAN scope. Choices: `global`, `portlocal`."
  type        = string
  default     = "global"

  validation {
    condition     = contains(["global", "portlocal"], var.vlan_scope)
    error_message = "Allowed values: `global` or `portlocal`."
  }
}

variable "qinq" {
  description = "QinQ mode. Choices: `disabled`, `edgePort`, `corePort`, `doubleQtagPort`."
  type        = string
  default     = "disabled"

  validation {
    condition     = contains(["disabled", "edgePort", "corePort", "doubleQtagPort"], var.qinq)
    error_message = "Allowed values: `disabled`, `edgePort`, `corePort` or `doubleQtagPort`."
  }
}


variable "reflective_relay" {
  description = "Reflective Relay (802.1Qbg)"
  type        = bool
  default     = false
}