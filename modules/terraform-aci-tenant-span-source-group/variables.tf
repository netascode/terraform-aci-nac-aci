variable "tenant" {
  description = "Tenant name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.tenant))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "name" {
  description = "SPAN source group name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.name))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "description" {
  description = "SPAN source group description."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9\\\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", var.description))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, }`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }
}

variable "admin_state" {
  description = "SPAN source group administrative state."
  type        = bool
  default     = true
}

variable "destination" {
  description = "SPAN source destination group name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.destination))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "sources" {
  description = "List of SPAN sources. Choices `direction`: `in`, `both`, `out`. Default value `direction`: `both`. "
  type = list(object({
    name                = string
    description         = optional(string, "")
    direction           = optional(string, "both")
    application_profile = optional(string)
    endpoint_group      = optional(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for s in var.sources : can(regex("^[a-zA-Z0-9_.:-]{0,64}$", s.name))
    ])
    error_message = "Source `name`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for s in var.sources : can(regex("^[a-zA-Z0-9\\\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", s.description))
    ])
    error_message = "Source `description`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, }`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }

  validation {
    condition = alltrue([
      for s in var.sources : contains(["in", "both", "out"], s.direction)
    ])
    error_message = "Source `direction`: Valid values are `in`, `both` or `out`."
  }

  validation {
    condition = alltrue([
      for s in var.sources : s.application_profile == null || can(regex("^[a-zA-Z0-9_.:-]{0,64}$", s.application_profile))
    ])
    error_message = "Source `application_profile`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for s in var.sources : s.endpoint_group == null || can(regex("^[a-zA-Z0-9_.:-]{0,64}$", s.endpoint_group))
    ])
    error_message = "Source `endpoint_group`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}
