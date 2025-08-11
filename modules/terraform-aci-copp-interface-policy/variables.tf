variable "name" {
  description = "CoPP Interface policy name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.name))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "description" {
  description = "CoPP Interface policy description."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", var.description))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, }`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }
}

variable "protocol_policies" {
  description = "CoPP protocol policies."
  type = list(object({
    name            = string
    rate            = optional(string, 10)
    burst           = optional(string, 10)
    match_protocols = optional(list(string), null)
  }))
  default = []

  validation {
    condition = alltrue([
      for pp in var.protocol_policies : can(regex("^[a-zA-Z0-9_.:-]{0,64}$", pp.name))
    ])
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for pp in var.protocol_policies : try(tonumber(pp.burst) >= 10, false) && try(tonumber(pp.burst) <= 549755813760, false)
    ])
    error_message = "Allowed Values: A number between 10 and 549,755,813,760."
  }

  validation {
    condition = alltrue([
      for pp in var.protocol_policies : try(tonumber(pp.rate) >= 10, false) && try(tonumber(pp.rate) <= 4398046510080, false)
    ])
    error_message = "Allowed Values: A number between 10 and 4,398,046,510,080."
  }

  validation {
    condition = alltrue(flatten([
      for pp in coalesce(var.protocol_policies, []) : [for mp in coalesce(pp.match_protocols, []) : contains(["icmp", "arp", "stp", "lldp", "bgp", "ospf", "bfd", "lacp", "cdp"], mp)]
    ]))
    error_message = "`match_protocol`: Allowed Values: `icmp`, `arp`, `stp`, `lldp`, `bgp`, `ospf`, `bfd`, `lacp`, `cdp`."
  }
}