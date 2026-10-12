variable "name" {
  description = "IP address pool name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.name))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "tenant" {
  description = "Tenant name. Choices: `mgmt`, `common`."
  type        = string

  validation {
    condition     = contains(["mgmt", "common"], var.tenant)
    error_message = "Allowed values: `mgmt` or `common`."
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

variable "gateway_address" {
  description = "Gateway IP address in CIDR notation."
  type        = string
}

variable "skip_gateway_validation" {
  description = "Skip gateway validation."
  type        = bool
  default     = false
}

variable "address_ranges" {
  description = "List of address ranges."
  type = list(object({
    from = string
    to   = string
  }))
  default = []
}
