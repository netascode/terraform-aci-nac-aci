variable "tenant" {
  description = "Tenant name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.tenant))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "name" {
  description = "BGP timer policy name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.name))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
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

variable "graceful_restart_helper" {
  description = "Graceful restart helper."
  type        = bool
  default     = true
}

variable "hold_interval" {
  description = "Hold interval. Allowed values: 0, 3-3600."
  type        = number
  default     = 180

  validation {
    condition     = var.hold_interval == 0 || (var.hold_interval >= 3 && var.hold_interval <= 3600)
    error_message = "Allowed values: 0, 3-3600."
  }
}

variable "keepalive_interval" {
  description = "Keepalive interval. Minimum value: 0. Maximum value: 3600."
  type        = number
  default     = 60

  validation {
    condition     = var.keepalive_interval >= 0 && var.keepalive_interval <= 3600
    error_message = "Minimum value: 0. Maximum value: 3600."
  }
}

variable "maximum_as_limit" {
  description = "Maximum AS limit. Minimum value: 0. Maximum value: 2000."
  type        = number
  default     = 0

  validation {
    condition     = var.maximum_as_limit >= 0 && var.maximum_as_limit <= 2000
    error_message = "Minimum value: 0. Maximum value: 2000."
  }
}

variable "stale_interval" {
  description = "Stale interval. Allowed values: `default` or a number between 1 and 3600."
  type        = string
  default     = "default"

  validation {
    condition     = var.stale_interval == "default" || try(tonumber(var.stale_interval) >= 1 && tonumber(var.stale_interval) <= 3600, false)
    error_message = "Allowed values: `default` or a number between 1 and 3600."
  }
}
