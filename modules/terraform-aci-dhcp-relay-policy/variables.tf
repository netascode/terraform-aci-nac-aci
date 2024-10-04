variable "tenant" {
  description = "Tenant name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.tenant))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "name" {
  description = "DHCP relay policy name."
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

variable "providers_" {
  description = "List of DHCP providers. Choices `type`: `epg`, `external_epg`."
  type = list(object({
    ip                      = string
    type                    = string
    tenant                  = optional(string)
    application_profile     = optional(string)
    endpoint_group          = optional(string)
    l3out                   = optional(string)
    external_endpoint_group = optional(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for p in var.providers_ : p.type == null || try(contains(["epg", "external_epg"], p.type), false)
    ])
    error_message = "`type`: Allowed values are `epg` or `external_epg`."
  }

  validation {
    condition = alltrue([
      for p in var.providers_ : p.tenant == null || can(regex("^[a-zA-Z0-9_.:-]{0,64}$", p.tenant))
    ])
    error_message = "`tenant`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for p in var.providers_ : p.application_profile == null || can(regex("^[a-zA-Z0-9_.:-]{0,64}$", p.application_profile))
    ])
    error_message = "`application_profile`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for p in var.providers_ : p.endpoint_group == null || can(regex("^[a-zA-Z0-9_.:-]{0,64}$", p.endpoint_group))
    ])
    error_message = "`endpoint_group`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for p in var.providers_ : p.l3out == null || can(regex("^[a-zA-Z0-9_.:-]{0,64}$", p.l3out))
    ])
    error_message = "`l3out`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for p in var.providers_ : p.external_endpoint_group == null || can(regex("^[a-zA-Z0-9_.:-]{0,64}$", p.external_endpoint_group))
    ])
    error_message = "`external_endpoint_group`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}
