variable "tenant" {
  description = "HSRP Interface Policy Tenant name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.tenant))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "name" {
  description = "HSRP interface policy name."
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

variable "bfd_enable" {
  description = "Enable BFD for HSRP interface. Controls BFD fast failure detection."
  type        = bool
  default     = false
}

variable "use_bia" {
  description = "Use Burned-In Address (BIA) for HSRP MAC address. When enabled, uses the interface's BIA as HSRP virtual MAC address."
  type        = bool
  default     = false
}

variable "delay" {
  description = "Minimum delay interval in seconds. Specifies the minimum time that must elapse before HSRP initializes."
  type        = number
  default     = 0

  validation {
    condition     = var.delay >= 0 && var.delay <= 10000
    error_message = "Allowed values are between 0 and 10000."
  }
}

variable "reload_delay" {
  description = "Reload delay interval in seconds. Delay after reload before HSRP activates."
  type        = number
  default     = 0

  validation {
    condition     = var.reload_delay >= 0 && var.reload_delay <= 10000
    error_message = "Allowed values are between 0 and 10000."
  }
}
