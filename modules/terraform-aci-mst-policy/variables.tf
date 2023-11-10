variable "name" {
  description = "MST policy name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.name))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "region" {
  description = "MST region."
  type        = string
}

variable "revision" {
  description = "MST revision."
  type        = number

  validation {
    condition     = var.revision >= 0 && var.revision <= 65535
    error_message = "Minimum value: 0. Maximum value: 65535."
  }
}

variable "instances" {
  description = "List of instances. Allowed values `id`: 1-4096. Allowed values `from`: 1-4096. Allowed values `to`: 1-4096. Default value `to`: value of `from`."
  type = list(object({
    name = string
    id   = number
    vlan_ranges = optional(list(object({
      from = number
      to   = optional(number)
    })), [])
  }))
  default = []

  validation {
    condition = alltrue([
      for i in var.instances : can(regex("^[a-zA-Z0-9_.-]{0,64}$", i.name))
    ])
    error_message = "`name`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for i in var.instances : i.id >= 1 && i.id <= 4096
    ])
    error_message = "`id`: Minimum value: 1. Maximum value: 4096."
  }

  validation {
    condition = alltrue(flatten([
      for i in var.instances : [for vr in coalesce(i.vlan_ranges, []) : (vr.from >= 1 && vr.from <= 4096)]
    ]))
    error_message = "`from`: Minimum value: 1. Maximum value: 4096."
  }

  validation {
    condition = alltrue(flatten([
      for i in var.instances : [for vr in coalesce(i.vlan_ranges, []) : vr.to == null || try(vr.to >= 1 && vr.to <= 4096, false)]
    ]))
    error_message = "`to`: Minimum value: 1. Maximum value: 4096."
  }
}
