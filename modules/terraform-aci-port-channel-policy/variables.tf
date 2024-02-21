variable "name" {
  description = "Port channel policy name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.name))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "mode" {
  description = "Mode. Choices: `off`, `active`, `passive`, `mac-pin`, `mac-pin-nicload`."
  type        = string

  validation {
    condition     = contains(["off", "active", "passive", "mac-pin", "mac-pin-nicload"], var.mode)
    error_message = "Allowed values are `off`, `active`, `passive`, `mac-pin` or `mac-pin-nicload`."
  }
}

variable "min_links" {
  description = "Minimum links. Minimum value: 1. Maximum value: 16."
  type        = number
  default     = 1

  validation {
    condition     = var.min_links >= 1 && var.min_links <= 16
    error_message = "Minimum value: 1. Maximum value: 16."
  }
}

variable "max_links" {
  description = "Maximum links. Minimum value: 1. Maximum value: 16."
  type        = number
  default     = 16

  validation {
    condition     = var.max_links >= 1 && var.max_links <= 16
    error_message = "Minimum value: 1. Maximum value: 16."
  }
}

variable "suspend_individual" {
  description = "Suspend individual."
  type        = bool
  default     = true
}

variable "graceful_convergence" {
  description = "Graceful convergence."
  type        = bool
  default     = true
}

variable "fast_select_standby" {
  description = "Fast select standby."
  type        = bool
  default     = true
}

variable "load_defer" {
  description = "Load defer."
  type        = bool
  default     = false
}

variable "symmetric_hash" {
  description = "Symmetric hash."
  type        = bool
  default     = false
}

variable "hash_key" {
  description = "Hash key. Choices: ``, `src-ip`, `dst-ip`, `l4-src-port`, `l4-dst-port`."
  type        = string
  default     = ""

  validation {
    condition     = contains(["", "src-ip", "dst-ip", "l4-src-port", "l4-dst-port"], var.hash_key)
    error_message = "Allowed values are ``, `src-ip`, `dst-ip`, `l4-src-port` or `l4-dst-port`."
  }
}
