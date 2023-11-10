variable "name" {
  description = "Node name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.name))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "node_id" {
  description = "Node ID. Minimum value: 1. Maximum value: 4000."
  type        = number

  validation {
    condition     = var.node_id >= 1 && var.node_id <= 4000
    error_message = "Minimum value: 1. Maximum value: 4000."
  }
}

variable "pod_id" {
  description = "Pod ID. Minimum value: 1. Maximum value: 255."
  type        = number
  default     = 1

  validation {
    condition     = var.pod_id >= 1 && var.pod_id <= 255
    error_message = "Minimum value: 1. Maximum value: 255."
  }
}

variable "serial_number" {
  description = "Serial number."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{1,16}$", var.serial_number))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 16."
  }
}

variable "type" {
  description = "Node type. Choices: `remote-leaf-wan`, `virtual`, `tier-2-leaf`, `unspecified`."
  type        = string
  default     = "unspecified"

  validation {
    condition     = contains(["remote-leaf-wan", "virtual", "tier-2-leaf", "unspecified"], var.type)
    error_message = "Allowed values: `remote-leaf-wan`, `virtual`, `tier-2-leaf` or `unspecified`."
  }
}

variable "remote_pool_id" {
  description = "Remote Pool ID. Minimum value: 0. Maximum value: 255"
  type        = number
  default     = 0

  validation {
    condition     = var.remote_pool_id >= 0 && var.remote_pool_id <= 255
    error_message = "Minimum value: 0. Maximum value: 255."
  }
}
