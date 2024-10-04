variable "name" {
  description = "VSPAN destination group name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.name))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "description" {
  description = "VSPAN destination group description."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9\\\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", var.description))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, }`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }
}

variable "destinations" {
  description = "List of VSPAN destinations."
  type = list(object({
    description         = optional(string, "")
    name                = string
    tenant              = optional(string)
    application_profile = optional(string)
    endpoint_group      = optional(string)
    endpoint            = optional(string)
    ip                  = optional(string)
    mtu                 = optional(number, 1518)
    ttl                 = optional(number, 64)
    flow_id             = optional(number, 1)
    dscp                = optional(string, "unspecified")
  }))
  default = []


  validation {
    condition = alltrue([
      for d in var.destinations : can(regex("^[a-zA-Z0-9_.:-]{0,64}$", d.name))
    ])
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for d in var.destinations : can(regex("^[a-zA-Z0-9\\\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", d.description))
    ])
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, }`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }

  validation {
    condition = alltrue([
      for d in var.destinations : d.tenant == null || can(regex("^[a-zA-Z0-9_.:-]{0,64}$", d.tenant))
    ])
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for d in var.destinations : d.application_profile == null || can(regex("^[a-zA-Z0-9_.:-]{0,64}$", d.application_profile))
    ])
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for d in var.destinations : d.endpoint_group == null || can(regex("^[a-zA-Z0-9_.:-]{0,64}$", d.endpoint_group))
    ])
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for d in var.destinations : d.endpoint == null || can(regex("^[a-zA-Z0-9_.:-]{0,64}$", d.endpoint))
    ])
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for d in var.destinations : try(contains(["unspecified", "CS0", "CS1", "AF11", "AF12", "AF13", "CS2", "AF21", "AF22", "AF23", "CS3", "AF31", "AF32", "AF33", "CS4", "AF41", "AF42", "AF43", "CS5", "VA", "EF", "CS6", "CS7"], d.dscp), false) || try(tonumber(d.dscp) >= 0 && tonumber(d.dscp) <= 63, false)
    ])
    error_message = "Allowed values are `unspecified`, `CS0`, `CS1`, `AF11`, `AF12`, `AF13`, `CS2`, `AF21`, `AF22`, `AF23`, `CS3`, `AF31`, `AF32`, `AF33`, `CS4`, `AF41`, `AF42`, `AF43`, `CS5`, `VA`, `EF`, `CS6`, `CS7` or a number between 0 and 63."
  }

  validation {
    condition = alltrue([
      for d in var.destinations : try(d.flow_id >= 1 && d.flow_id <= 1023, false)
    ])
    error_message = "Allowed values: 1-1023."
  }

  validation {
    condition = alltrue([
      for d in var.destinations : try(d.mtu >= 64 && d.mtu <= 9216, false)
    ])
    error_message = "Allowed values: 64-9216."
  }

  validation {
    condition = alltrue([
      for d in var.destinations : try(d.ttl >= 1 && d.ttl <= 255, false)
    ])
    error_message = "Allowed values: 1-255."
  }
}
