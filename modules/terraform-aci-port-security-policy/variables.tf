variable "name" {
  description = "Port security policy name."
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

variable "maximum_endpoints" {
  description = "Maximum number of endpoints. A value of 0 means unlimited."
  type        = number
  default     = 0

  validation {
    condition     = var.maximum_endpoints >= 0 && var.maximum_endpoints <= 12000
    error_message = "Minimum value: 0, Maximum value: 12000."
  }
}

variable "timeout" {
  description = "Port security timeout in seconds."
  type        = number
  default     = 60

  validation {
    condition     = var.timeout >= 60 && var.timeout <= 3600
    error_message = "Minimum value: 60, Maximum value: 3600."
  }
}
