variable "interface_profile" {
  description = "Spine interface profile name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.interface_profile))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "name" {
  description = "Spine interface selector name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.name))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "policy_group" {
  description = "Interface policy group name."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.policy_group))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "port_blocks" {
  description = "List of port blocks. Allowed values `from_module`, `to_module`: 1-9. Default value `from_module`, `to_module`: 1. Allowed values `from_port`, `to_port`: 1-127. Default value `to_port`: `from_port`."
  type = list(object({
    name        = string
    description = optional(string, "")
    from_module = optional(number, 1)
    to_module   = optional(number)
    from_port   = number
    to_port     = optional(number)
  }))
  default = []

  validation {
    condition = alltrue([
      for pb in var.port_blocks : can(regex("^[a-zA-Z0-9_.:-]{0,64}$", pb.name))
    ])
    error_message = "`name`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for pb in var.port_blocks : can(regex("^[a-zA-Z0-9\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", pb.description))
    ])
    error_message = "`description`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, }`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }

  validation {
    condition = alltrue([
      for pb in var.port_blocks : pb.from_module == null || try(pb.from_module >= 1 && pb.from_module <= 9, false)
    ])
    error_message = "`from_module`: Minimum value: 1. Maximum value: 9."
  }

  validation {
    condition = alltrue([
      for pb in var.port_blocks : pb.to_module == null || try(pb.to_module >= 1 && pb.to_module <= 9, false)
    ])
    error_message = "`to_module`: Minimum value: 1. Maximum value: 9."
  }

  validation {
    condition = alltrue([
      for pb in var.port_blocks : pb.from_port >= 1 && pb.from_port <= 127
    ])
    error_message = "`from_port`: Minimum value: 1. Maximum value: 127."
  }

  validation {
    condition = alltrue([
      for pb in var.port_blocks : pb.to_port == null || try(pb.to_port >= 1 && pb.to_port <= 127, false)
    ])
    error_message = "`to_port`: Minimum value: 1. Maximum value: 127."
  }
}
