variable "name" {
  description = "TACACS monitoring destination group name."
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

variable "destinations" {
  description = "List of TACACS destinations. Allowed values `port`: 1-65535. Default value `port`: 49. Choices `protocol`: `pap`, `chap`, `mschap`. Default value `protocol`: `pap`. Choices `mgmt_epg_type`: `inb`, `oob`. Default value `mgmt_epg_type`: `oob`."
  type = list(object({
    hostname_ip   = string
    port          = optional(number, 49)
    protocol      = optional(string, "pap")
    key           = optional(string)
    mgmt_epg_type = optional(string, "oob")
    mgmt_epg_name = optional(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for d in var.destinations : can(regex("^[a-zA-Z0-9:][a-zA-Z0-9.:-]{0,254}$", d.hostname_ip))
    ])
    error_message = "Allowed characters `hostname_ip`: `a`-`z`, `A`-`Z`, `0`-`9`, `.`, `:`, `-`. Maximum characters: 254."
  }

  validation {
    condition = alltrue([
      for d in var.destinations : try(d.port >= 1 && d.port <= 65535, false)
    ])
    error_message = "`port`: Minimum value: 1. Maximum value: 65535."
  }

  validation {
    condition = alltrue([
      for d in var.destinations : try(contains(["pap", "chap", "mschap"], d.protocol), false)
    ])
    error_message = "`protocol`: Allowed values are `pap`, `chap` or `mschap`."
  }

  validation {
    condition = alltrue([
      for d in var.destinations : try(contains(["inb", "oob"], d.mgmt_epg_type), false)
    ])
    error_message = "`mgmt_epg_type`: Allowed values are `inb` or `oob`."
  }

  validation {
    condition = alltrue([
      for d in var.destinations : d.mgmt_epg_name == null || can(regex("^[a-zA-Z0-9_.:-]{1,64}$", d.mgmt_epg_name))
    ])
    error_message = "Allowed characters `mgmt_epg_name`: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}
