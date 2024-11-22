variable "tenant" {
  description = "Tenant name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.tenant))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "name" {
  description = "ND RA prefix policy name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.name))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "description" {
  description = "Description."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9\\\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", var.description))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, }`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }
}

variable "valid_lifetime" {
  description = "Valid lifetime. Minimum value: 0. Maximum value: 4294967295."
  type        = number
  default     = 2592000

  validation {
    condition     = var.valid_lifetime >= 0 && var.valid_lifetime <= 4294967295
    error_message = "Minimum value: 0. Maximum value: 4294967295."
  }
}

variable "preferred_lifetime" {
  description = "Preferred lifetime. Minimum value: 0. Maximum value: 4294967295."
  type        = number
  default     = 604800

  validation {
    condition     = var.preferred_lifetime >= 0 && var.preferred_lifetime <= 4294967295
    error_message = "Minimum value: 0. Maximum value: 4294967295."
  }
}

variable "auto_configuration" {
  description = "Auto configuration."
  type        = bool
  default     = true
}

variable "on_link" {
  description = "On link."
  type        = bool
  default     = true
}

variable "router_address" {
  description = "Router address."
  type        = bool
  default     = false
}
