variable "tenant" {
  description = "Tenant name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.tenant))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "name" {
  description = "Endpoint Retention policy name."
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
    condition     = can(regex("^[a-zA-Z0-9\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", var.description))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, }`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }
}

variable "hold_interval" {
  description = "APIC Endpoint Retention hold interval. Minimum value: 5. Maximum value: 65535."
  type        = number
  default     = 300

  validation {
    condition     = var.hold_interval >= 5 && var.hold_interval <= 65535
    error_message = "Minimum value: 5. Maximum value: 65535."
  }
}

variable "bounce_entry_aging" {
  description = "APIC Endpoint Retention bounce entry aging. Minimum value: 150. Maximum value: 65535."
  type        = number
  default     = 630

  validation {
    condition     = var.bounce_entry_aging >= 150 && var.bounce_entry_aging <= 65535
    error_message = "Minimum value: 150. Maximum value: 65535."
  }
}
variable "local_endpoint_aging" {
  description = "APIC Endpoint Retention local endpoint aging. Minimum value: 120. Maximum value: 65535."
  type        = number
  default     = 900

  validation {
    condition     = var.local_endpoint_aging >= 120 && var.local_endpoint_aging <= 65535
    error_message = "Minimum value: 120. Maximum value: 65535."
  }
}
variable "remote_endpoint_aging" {
  description = "APIC Endpoint Retention remote endpoint aging. Minimum value: 120. Maximum value: 65535."
  type        = number
  default     = 300

  validation {
    condition     = var.remote_endpoint_aging >= 120 && var.remote_endpoint_aging <= 65535
    error_message = "Minimum value: 120. Maximum value: 65535."
  }
}
variable "move_frequency" {
  description = "APIC Endpoint Retention hold interval. Minimum value: 5. Maximum value: 65535."
  type        = number
  default     = 300

  validation {
    condition     = var.move_frequency >= 0 && var.move_frequency <= 65535
    error_message = "Minimum value: 0. Maximum value: 65535."
  }
}