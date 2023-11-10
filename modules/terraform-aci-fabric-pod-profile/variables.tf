variable "name" {
  description = "Fabric pod profile name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.name))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "selectors" {
  description = "List of selectors. ALlowed values `type`: `all`, `range`. Default value `type`: `range`. Allowed values `from`: 1-255. Allowed values `to`: 1-255."
  type = list(object({
    name         = string
    policy_group = optional(string)
    type         = optional(string, "range")
    pod_blocks = optional(list(object({
      name = string
      from = number
      to   = optional(number)
    })), [])
  }))
  default = []

  validation {
    condition = alltrue([
      for s in var.selectors : can(regex("^[a-zA-Z0-9_.-]{0,64}$", s.name))
    ])
    error_message = "`name`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for s in var.selectors : s.policy_group == null || can(regex("^[a-zA-Z0-9_.-]{0,64}$", s.policy_group))
    ])
    error_message = "`policy_group`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for s in var.selectors : contains(["all", "range"], s.type)
    ])
    error_message = "`type`: Allowed values are `all` or `range`."
  }

  validation {
    condition = alltrue(flatten([
      for s in var.selectors : [for pb in coalesce(s.pod_blocks, []) : can(regex("^[a-zA-Z0-9_.-]{0,64}$", pb.name))]
    ]))
    error_message = "`pod_blocks.name`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue(flatten([
      for s in var.selectors : [for pb in coalesce(s.pod_blocks, []) : (pb.from >= 1 && pb.from <= 255)]
    ]))
    error_message = "`from`: Minimum value: 1. Maximum value: 255."
  }

  validation {
    condition = alltrue(flatten([
      for s in var.selectors : [for pb in coalesce(s.pod_blocks, []) : (pb.to == null || try(pb.to >= 1 && pb.to <= 255, false))]
    ]))
    error_message = "`to`: Minimum value: 1. Maximum value: 255."
  }
}
