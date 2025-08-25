variable "tenant" {
  description = "Tenant name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.tenant))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "name" {
  description = "L3out name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.name))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "alias" {
  description = "Alias."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.alias))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "annotation" {
  description = "Annotation value."
  type        = string
  default     = null

  validation {
    condition     = var.annotation == null || can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.annotation))
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

variable "routed_domain" {
  description = "Routed domain name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.routed_domain))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "vrf" {
  description = "VRF name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.vrf))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "ospf" {
  description = "Enable OSPF routing."
  type        = bool
  default     = false
}

variable "bgp" {
  description = "Enable BGP routing."
  type        = bool
  default     = false
}

variable "eigrp" {
  description = "Enable EIGRP routing."
  type        = bool
  default     = false
}

variable "ospf_area" {
  description = "OSPF area. Allowed values are `backbone`, a number between 1 and 4294967295, or an ID in IP address format."
  type        = string
  default     = "backbone"

  validation {
    condition     = try(contains(["backbone"], var.ospf_area), false) || (try(tonumber(var.ospf_area), false) != false ? tonumber(var.ospf_area) >= 1 && tonumber(var.ospf_area) <= 4294967295 : false) || try(can(regex("^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$", var.ospf_area)), false)
    error_message = "Allowed values are `backbone`, a number between 1 and 4294967295, or an ID in IP address format."
  }
}

variable "ospf_area_cost" {
  description = "OSPF area cost. Minimum value: 1. Maximum value: 16777215."
  type        = number
  default     = 1

  validation {
    condition     = var.ospf_area_cost >= 1 && var.ospf_area_cost <= 16777215
    error_message = "Minimum value: 1. Maximum value: 16777215."
  }
}

variable "ospf_area_type" {
  description = "OSPF area type. Choices: `regular`, `stub`, `nssa`."
  type        = string
  default     = "regular"

  validation {
    condition     = contains(["regular", "stub", "nssa"], var.ospf_area_type)
    error_message = "Allowed values are `regular`, `stub` or `nssa`."
  }
}

variable "ospf_area_control_redistribute" {
  description = "Send redistributed LSAs into NSSA area."
  type        = bool
  default     = true
}

variable "ospf_area_control_summary" {
  description = "Originate summary LSA."
  type        = bool
  default     = true
}

variable "ospf_area_control_suppress_fa" {
  description = "Suppress forwarding address in translated LSA."
  type        = bool
  default     = false
}

variable "eigrp_asn" {
  description = "EIGRP Autonomous System Number area cost. Minimum value: 1. Maximum value: 65535."
  type        = number
  default     = 1

  validation {
    condition     = var.eigrp_asn >= 1 && var.eigrp_asn <= 65535
    error_message = "Minimum value: 1. Maximum value: 65535."
  }
}

variable "l3_multicast_ipv4" {
  description = "L3 IPv4 Multicast."
  type        = bool
  default     = false
}

variable "target_dscp" {
  description = "Target DSCP. Choices: `CS0`, `CS1`, `AF11`, `AF12`, `AF13`, `CS2`, `AF21`, `AF22`, `AF23`, `CS3`, `AF31`, `AF32`, `AF33`, `CS4`, `AF41`, `AF42`, `AF43`, `CS5`, `VA`, `EF`, `CS6`, `CS7`, `unspecified` or a number between `0` and `63`."
  type        = string
  default     = "unspecified"

  validation {
    condition     = contains(["CS0", "CS1", "AF11", "AF12", "AF13", "CS2", "AF21", "AF22", "AF23", "CS3", "AF31", "AF32", "AF33", "CS4", "AF41", "AF42", "AF43", "CS5", "VA", "EF", "CS6", "CS7", "unspecified"], var.target_dscp) || try(var.target_dscp >= 0 && var.target_dscp <= 63, false)
    error_message = "Allowed values are `CS0`, `CS1`, `AF11`, `AF12`, `AF13`, `CS2`, `AF21`, `AF22`, `AF23`, `CS3`, `AF31`, `AF32`, `AF33`, `CS4`, `AF41`, `AF42`, `AF43`, `CS5`, `VA`, `EF`, `CS6`, `CS7`, `unspecified or a number between `0` and `63`."
  }
}

variable "import_route_control_enforcement" {
  description = "L3 Import Route-Control Enforcement."
  type        = bool
  default     = false
}

variable "export_route_control_enforcement" {
  description = "L3 Export Route-Control Enforcement."
  type        = bool
  default     = true
}

variable "interleak_route_map" {
  description = "Interleak route map name."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.interleak_route_map))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "dampening_ipv4_route_map" {
  description = "Dampening IPv4 route map name."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.dampening_ipv4_route_map))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "dampening_ipv6_route_map" {
  description = "Dampening IPv6 route map name."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.dampening_ipv6_route_map))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "default_route_leak_policy" {
  description = "Default route leak policy."
  type        = bool
  default     = false
}

variable "default_route_leak_policy_always" {
  description = "Default route leak policy always."
  type        = bool
  default     = false
}

variable "default_route_leak_policy_criteria" {
  description = "Default route leak policy criteria. Choices: `only`, `in-addition`."
  type        = string
  default     = "only"

  validation {
    condition     = contains(["only", "in-addition"], var.default_route_leak_policy_criteria)
    error_message = "Allowed values are `only` or `in-addition`."
  }
}

variable "default_route_leak_policy_context_scope" {
  description = "Default route leak policy context scope."
  type        = bool
  default     = true
}

variable "default_route_leak_policy_outside_scope" {
  description = "Default route leak policy outside scope."
  type        = bool
  default     = true
}

variable "redistribution_route_maps" {
  description = "List of redistribution route maps. Choices `source`: `direct`, `attached-host`, `static`. Default value `source`: `static`."
  type = list(object({
    source    = optional(string, "static")
    route_map = string
  }))
  default = []

  validation {
    condition = alltrue([
      for r in var.redistribution_route_maps : r.source == null || try(contains(["direct", "attached-host", "static"], r.source), false)
    ])
    error_message = "`source`: Allowed values are `direct`, `attached-host` or `static`."
  }

  validation {
    condition = alltrue([
      for r in var.redistribution_route_maps : can(regex("^[a-zA-Z0-9_.:-]{0,64}$", r.route_map))
    ])
    error_message = "`route_map`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "import_route_map_name" {
  description = "Import Route Map Name. Default value: `default-import`"
  type        = string
  default     = "default-import"

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.import_route_map_name))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "import_route_map_description" {
  description = "Import route map description."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9\\\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", var.import_route_map_description))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, }`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }
}

variable "import_route_map_type" {
  description = "Import route map type. Choices: `combinable`, `global`."
  type        = string
  default     = "combinable"

  validation {
    condition     = contains(["combinable", "global"], var.import_route_map_type)
    error_message = "Allowed values are `combinable` or `global`."
  }
}

variable "import_route_map_contexts" {
  description = "List of import route map contexts. Choices `action`: `permit`, `deny`. Default value `action`: `permit`. Allowed values `order`: 0-9. Default value `order`: 0."
  type = list(object({
    name        = string
    description = optional(string, "")
    action      = optional(string, "permit")
    order       = optional(number, 0)
    set_rule    = optional(string)
    match_rules = optional(list(string), [])
  }))
  default = []

  validation {
    condition = alltrue([
      for c in var.import_route_map_contexts : can(regex("^[a-zA-Z0-9_.:-]{0,64}$", c.name))
    ])
    error_message = "`name`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for c in var.import_route_map_contexts : c.description == null || try(can(regex("^[a-zA-Z0-9\\\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", c.description)), false)
    ])
    error_message = "`name`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, }`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }

  validation {
    condition = alltrue([
      for c in var.import_route_map_contexts : c.action == null || try(contains(["permit", "deny"], c.action), false)
    ])
    error_message = "`action`: Allowed values are `permit` or `deny`."
  }

  validation {
    condition = alltrue([
      for c in var.import_route_map_contexts : c.order == null || try(c.order >= 0 && c.order <= 9, false)
    ])
    error_message = "`order`: Minimum value: 0. Maximum value: 9."
  }

  validation {
    condition = alltrue([
      for c in var.import_route_map_contexts : c.set_rule == null || try(can(regex("^[a-zA-Z0-9_.:-]{0,64}$", c.set_rule)), false)
    ])
    error_message = "`set_rule`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue(flatten([
      for c in var.import_route_map_contexts : [
        for r in c.match_rules : r == null || try(can(regex("^[a-zA-Z0-9_.:-]{0,64}$", r)), false)
      ]
    ]))
    error_message = "`match_rules`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "export_route_map_name" {
  description = "Export Route Map Name. Default value: `default-export`"
  type        = string
  default     = "default-export"

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.export_route_map_name))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "export_route_map_description" {
  description = "Import route map description."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9\\\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", var.export_route_map_description))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, }`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }
}

variable "export_route_map_type" {
  description = "Import route map type. Choices: `combinable`, `global`."
  type        = string
  default     = "combinable"

  validation {
    condition     = contains(["combinable", "global"], var.export_route_map_type)
    error_message = "Allowed values are `combinable` or `global`."
  }
}

variable "export_route_map_contexts" {
  description = "List of export route map contexts. Choices `action`: `permit`, `deny`. Default value `action`: `permit`. Allowed values `order`: 0-9. Default value `order`: 0."
  type = list(object({
    name        = string
    description = optional(string, "")
    action      = optional(string, "permit")
    order       = optional(number, 0)
    set_rule    = optional(string)
    match_rules = optional(list(string), [])
  }))
  default = []

  validation {
    condition = alltrue([
      for c in var.export_route_map_contexts : can(regex("^[a-zA-Z0-9_.:-]{0,64}$", c.name))
    ])
    error_message = "`name`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for c in var.export_route_map_contexts : c.description == null || try(can(regex("^[a-zA-Z0-9\\\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", c.description)), false)
    ])
    error_message = "`name`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, }`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }

  validation {
    condition = alltrue([
      for c in var.export_route_map_contexts : c.action == null || try(contains(["permit", "deny"], c.action), false)
    ])
    error_message = "`action`: Allowed values are `permit` or `deny`."
  }

  validation {
    condition = alltrue([
      for c in var.export_route_map_contexts : c.order == null || try(c.order >= 0 && c.order <= 9, false)
    ])
    error_message = "`order`: Minimum value: 0. Maximum value: 9."
  }

  validation {
    condition = alltrue([
      for c in var.export_route_map_contexts : c.set_rule == null || try(can(regex("^[a-zA-Z0-9_.:-]{0,64}$", c.set_rule)), false)
    ])
    error_message = "`set_rule`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue(flatten([
      for c in var.export_route_map_contexts : [
        for r in c.match_rules : r == null || try(can(regex("^[a-zA-Z0-9_.:-]{0,64}$", r)), false)
      ]
    ]))
    error_message = "`match_rules`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "route_maps" {
  description = "List of route maps"
  type = list(object({
    name        = string
    description = optional(string, "")
    type        = optional(string, "combinable")
    contexts = list(object({
      name        = string
      description = optional(string, "")
      action      = optional(string, "permit")
      order       = optional(number, 0)
      set_rule    = optional(string)
      match_rules = optional(list(string), [])
    }))
  }))
  default = []

  validation {
    condition = alltrue([
      for route_map in var.route_maps : can(regex("^[a-zA-Z0-9_.:-]{0,64}$", route_map.name))
    ])
    error_message = "`name`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
  validation {
    condition = alltrue([
      for route_map in var.route_maps : route_map.description == null || try(can(regex("^[a-zA-Z0-9\\\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", route_map.description)), false)
    ])
    error_message = "`description`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, }`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }
  validation {
    condition = alltrue([
      for route_map in var.route_maps : route_map.type == null || try(contains(["combinable", "global"], route_map.type), false)
    ])
    error_message = "`type`: Allowed values are `combinable` or `global`."
  }
  validation {
    condition = alltrue(flatten([
      for route_map in var.route_maps : [
        for context in route_map.contexts : can(regex("^[a-zA-Z0-9_.:-]{0,64}$", context.name))
      ]
    ]))
    error_message = "`contexts.name`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue(flatten([
      for route_map in var.route_maps : [
        for context in route_map.contexts : context.description == null || try(can(regex("^[a-zA-Z0-9\\\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", context.description)), false)
      ]
    ]))
    error_message = "`contexts.description`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, `}`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }

  validation {
    condition = alltrue(flatten([
      for route_map in var.route_maps : [
        for context in route_map.contexts : context.action == null || try(contains(["permit", "deny"], context.action), false)
      ]
    ]))
    error_message = "`contexts.action`: Allowed values are `permit` or `deny`."
  }

  validation {
    condition = alltrue(flatten([
      for route_map in var.route_maps : [
        for context in route_map.contexts : context.order == null || try(context.order >= 0 && context.order <= 9, false)
      ]
    ]))
    error_message = "`contexts.order`: Minimum value: 0. Maximum value: 9."
  }
  validation {
    condition = alltrue(flatten([
      for route_map in var.route_maps : [
        for context in route_map.contexts : context.set_rule == null || try(can(regex("^[a-zA-Z0-9_.:-]{0,64}$", context.set_rule)), false)
      ]
    ]))
    error_message = "`contexts.set_rule`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue(flatten(flatten([
      for route_map in var.route_maps : [
        for context in route_map.contexts : [
          for match_rule in context.match_rules : match_rule == null || try(can(regex("^[a-zA-Z0-9_.:-]{0,64}$", match_rule)), false)
        ]
      ]
    ])))
    error_message = "`contexts.match_rules`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }

}

variable "multipod" {
  description = "Multipod L3out flag."
  type        = bool
  default     = true
}

variable "sr_mpls" {
  description = "SR MPLS L3out flag."
  type        = bool
  default     = false
}

variable "sr_mpls_infra_l3outs" {
  description = "SR MPLS Infra L3Outs."
  type = list(object({
    name                     = string
    outbound_route_map       = optional(string, "")
    inbound_route_map        = optional(string, "")
    external_endpoint_groups = optional(list(string), [])
  }))
  default = []

  validation {
    condition = alltrue([
      for i in var.sr_mpls_infra_l3outs : can(regex("^[a-zA-Z0-9_.-]{0,64}$", i.name))
    ])
    error_message = "`name`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for i in var.sr_mpls_infra_l3outs : can(regex("^[a-zA-Z0-9_.-]{0,64}$", i.outbound_route_map))
    ])
    error_message = "`outbound_route_map`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for i in var.sr_mpls_infra_l3outs : can(regex("^[a-zA-Z0-9_.-]{0,64}$", i.inbound_route_map))
    ])
    error_message = "`inbound_route_map`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for i in var.sr_mpls_infra_l3outs : alltrue([
        for e in i.external_endpoint_groups : can(regex("^[a-zA-Z0-9_.-]{0,64}$", e))
      ])
    ])
    error_message = "`external_endpoint_groups`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}
