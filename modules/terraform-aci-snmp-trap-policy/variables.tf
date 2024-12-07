variable "name" {
  description = "SNMP trap policy name."
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
  description = "List of destinations. Allowed values `port`: 0-65535. Default value `port`: 162. Choices `security`: `noauth`, `auth`, `priv`. Default value `security`: `noauth`. Choices `version`: `v1`, `v2c`, `v3`. Default value `version`: `v2c`. Choices `mgmt_epg_type`: `inb`, `oob`. Default value `mgmt_epg_type`: `inb`."
  type = list(object({
    hostname_ip   = string
    port          = optional(number, 162)
    community     = string
    security      = optional(string, "noauth")
    version       = optional(string, "v2c")
    mgmt_epg_type = optional(string, "inb")
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
      for d in var.destinations : d.port == null || try(d.port >= 0 && d.port <= 65535, false)
    ])
    error_message = "`port`: Minimum value: 0. Maximum value: 65535."
  }

  validation {
    condition = alltrue([
      for d in var.destinations : can(regex("^.{1,32}$", d.community))
    ])
    error_message = "`community`: Maximum characters: 32."
  }

  validation {
    condition = alltrue([
      for d in var.destinations : d.security == null || try(contains(["noauth", "auth", "priv"], d.security), false)
    ])
    error_message = "`security`: Allowed values are `noauth`, `auth` or `priv`."
  }

  validation {
    condition = alltrue([
      for d in var.destinations : d.version == null || try(contains(["v1", "v2c", "v3"], d.version), false)
    ])
    error_message = "`version`: Allowed values are `v1`, `v2c` or `v3`."
  }

  validation {
    condition = alltrue([
      for d in var.destinations : d.mgmt_epg_type == null || try(contains(["inb", "oob"], d.mgmt_epg_type), false)
    ])
    error_message = "`mgmt_epg_type`: Allowed values are `inb` or `oob`."
  }

  validation {
    condition = alltrue([
      for d in var.destinations : can(regex("^[a-zA-Z0-9_.:-]{1,64}$", d.mgmt_epg_name))
    ])
    error_message = "Allowed characters `mgmt_epg_name`: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}
