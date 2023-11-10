variable "node_id" {
  description = "Node ID. Allowed values: 101-16000."
  type        = number

  validation {
    condition     = try(var.node_id >= 101 && var.node_id <= 16000, false)
    error_message = "Allowed values: 101-16000."
  }
}

variable "module" {
  description = "Module ID. Allowed values: 1-255."
  type        = number
  default     = 1

  validation {
    condition     = try(var.module >= 1 && var.module <= 255, false)
    error_message = "Allowed values: 1-255."
  }
}

variable "port" {
  description = "Interface ID. Allowed values: 1-127."
  type        = number
  default     = 1

  validation {
    condition     = try(var.port >= 1 && var.port <= 127, false)
    error_message = "Allowed charactvaluesers: 1-127."
  }
}

variable "sub_port" {
  description = "Subinterface ID. Allowed values: 1-64."
  type        = number
  default     = 0

  validation {
    condition     = try(var.sub_port >= 0 && var.sub_port <= 64, false)
    error_message = "Allowed characters: 1-127."
  }
}

variable "policy_group_type" {
  description = "Interface policy group type. Choices: `access`, `pc`, `vpc`."
  type        = string
  default     = "access"

  validation {
    condition     = contains(["access", "pc", "vpc"], var.policy_group_type)
    error_message = "Allowed values: `access`, `pc` or `vpc`."
  }
}

variable "policy_group" {
  description = "Interface policy group name."
  type        = string
  default     = "system-ports-default"

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.policy_group))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "breakout" {
  description = "Breakout Map. Allowed values: `none`, `100g-2x`, `100g-4x`, `10g-4x`, `25g-4x`, `50g-8x`. Default value: `none`."
  type        = string
  default     = "none"

  validation {
    condition     = contains(["none", "100g-2x", "100g-4x", "10g-4x", "25g-4x", "`50g-8x"], var.breakout)
    error_message = "Allowed values: `none`, `100g-2x`, `100g-4x`, `10g-4x`, `25g-4x`, `50g-8x`."
  }
}

variable "fex_id" {
  description = "FEX ID. Allowed values: 101-199. `0` meaning no FEX."
  type        = string
  default     = "unspecified"

  validation {
    condition     = try(contains(["unspecified"], var.fex_id), false) || try(tonumber(var.fex_id) == 0, false) || try(tonumber(var.fex_id) >= 101 && tonumber(var.fex_id) <= 65535, false)
    error_message = "Allowed values: 0, 101-199."
  }
}

variable "description" {
  description = "Description."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", var.description))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, }`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }
}

variable "role" {
  description = "Node role. Allowed values: `leaf`, `spine`."
  type        = string
  default     = "leaf"

  validation {
    condition     = contains(["leaf", "spine"], var.role)
    error_message = "Allowed values: `leaf`, `spine`."
  }
}
