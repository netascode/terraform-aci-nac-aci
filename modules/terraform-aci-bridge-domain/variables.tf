variable "tenant" {
  description = "Tenant name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.tenant))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "name" {
  description = "Bridge domain name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.name))
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

variable "alias" {
  description = "Alias."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.alias))
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

variable "arp_flooding" {
  description = "ARP flooding."
  type        = bool
  default     = false
}

variable "advertise_host_routes" {
  description = "Advertisement of host routes."
  type        = bool
  default     = false
}

variable "ip_dataplane_learning" {
  description = "IP data plane learning."
  type        = bool
  default     = true
}

variable "limit_ip_learn_to_subnets" {
  description = "Limit IP learning to subnets."
  type        = bool
  default     = true
}

variable "mac" {
  description = "MAC address. Format: `12:34:56:78:9A:BC`."
  type        = string
  default     = "00:22:BD:F8:19:FF"

  validation {
    condition     = can(regex("^([0-9A-Fa-f]{2}[:]){5}([0-9A-Fa-f]{2})$", var.mac))
    error_message = "Format: `12:34:56:78:9A:BC`."
  }
}

variable "ep_move_detection" {
  description = "Endpoint move detection flag."
  type        = bool
  default     = false
}

variable "clear_remote_mac_entries" {
  description = "Clear remote MAC entries flag."
  type        = bool
  default     = false
}

variable "multicast_arp_drop" {
  description = "Drop ARP with Multicast SMAC."
  type        = bool
  default     = null
}

variable "virtual_mac" {
  description = "Virtual MAC address. Format: `12:34:56:78:9A:BC`."
  type        = string
  default     = "not-applicable"

  validation {
    condition     = var.virtual_mac == "not-applicable" || can(regex("^([0-9A-Fa-f]{2}[:]){5}([0-9A-Fa-f]{2})$", var.virtual_mac))
    error_message = "Format: `12:34:56:78:9A:BC`."
  }
}

variable "l3_multicast" {
  description = "L3 multicast."
  type        = bool
  default     = false
}

variable "pim_source_filter" {
  description = "PIM source filter."
  type        = string
  default     = ""
}

variable "pim_destination_filter" {
  description = "PIM destination filter."
  type        = string
  default     = ""
}

variable "multi_destination_flooding" {
  description = "Multi destination flooding. Choices: `bd-flood`, `encap-flood`, `drop`."
  type        = string
  default     = "bd-flood"

  validation {
    condition     = contains(["bd-flood", "encap-flood", "drop"], var.multi_destination_flooding)
    error_message = "Valid values are `bd-flood`, `encap-flood` or `drop`."
  }
}

variable "unicast_routing" {
  description = "Unicast routing."
  type        = bool
  default     = true
}

variable "unknown_unicast" {
  description = "Unknown unicast forwarding behavior. Choices: `flood`, `proxy`."
  type        = string
  default     = "proxy"

  validation {
    condition     = contains(["flood", "proxy"], var.unknown_unicast)
    error_message = "Valid values are `flood` or `proxy`."
  }
}

variable "unknown_ipv4_multicast" {
  description = "Unknown IPv4 multicast forwarding behavior. Choices: `flood`, `opt-flood`."
  type        = string
  default     = "flood"

  validation {
    condition     = contains(["flood", "opt-flood"], var.unknown_ipv4_multicast)
    error_message = "Valid values are `flood` or `opt-flood`."
  }
}

variable "unknown_ipv6_multicast" {
  description = "Unknown IPV6 multicast forwarding behavior. Choices: `flood`, `opt-flood`."
  type        = string
  default     = "flood"

  validation {
    condition     = contains(["flood", "opt-flood"], var.unknown_ipv6_multicast)
    error_message = "Valid values are `flood` or `opt-flood`."
  }
}

variable "vrf" {
  description = "VRF name."
  type        = string
}

variable "igmp_interface_policy" {
  description = "IGMP interface policy."
  type        = string
  default     = ""
}

variable "igmp_snooping_policy" {
  description = "IGMP snooping policy."
  type        = string
  default     = ""
}

variable "nd_interface_policy" {
  description = "ND interface policy."
  type        = string
  default     = ""
}

variable "subnets" {
  description = "List of subnets. Default value `primary_ip`: `false`. Default value `public`: `false`. Default value `shared`: `false`. Default value `igmp_querier`: `false`. Default value `nd_ra_prefix`: `true`. Default value `no_default_gateway`: `false`. Default value `virtual`: `false`."
  type = list(object({
    description           = optional(string, "")
    ip                    = string
    primary_ip            = optional(bool, false)
    public                = optional(bool, false)
    shared                = optional(bool, false)
    igmp_querier          = optional(bool, false)
    nd_ra_prefix          = optional(bool, true)
    no_default_gateway    = optional(bool, false)
    virtual               = optional(bool, false)
    nd_ra_prefix_policy   = optional(string, "")
    ip_dataplane_learning = optional(bool, null)
    tags = optional(list(object({
      key   = string
      value = string
    })), [])
  }))
  default = []

  validation {
    condition = alltrue([
      for s in var.subnets : s.description == null || can(regex("^[a-zA-Z0-9\\\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", s.description))
    ])
    error_message = "`description`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, }`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }

  validation {
    condition = alltrue([
      for s in var.subnets : s.nd_ra_prefix_policy == null || can(regex("^[a-zA-Z0-9_.:-]{0,64}$", s.nd_ra_prefix_policy))
    ])
    error_message = "`nd_ra_prefix_policy`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for s in var.subnets : alltrue([
        for tag in coalesce(s.tags, []) : can(regex("^[a-zA-Z0-9_.:-]{0,64}$", tag.key))
      ])
    ])
    error_message = "`tags.key`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for s in var.subnets : alltrue([
        for tag in coalesce(s.tags, []) : can(regex("^[a-zA-Z0-9_.:-]{0,64}$", tag.value))
      ])
    ])
    error_message = "`tags.value`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "l3outs" {
  description = "List of l3outs"
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for l3out in var.l3outs : can(regex("^[a-zA-Z0-9_.:-]{0,64}$", l3out))
    ])
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "dhcp_labels" {
  description = "List of DHCP labels"
  type = list(object({
    dhcp_relay_policy  = string
    dhcp_option_policy = optional(string)
    scope              = optional(string, "tenant")
  }))
  default = []

  validation {
    condition = alltrue([
      for l in var.dhcp_labels : l.dhcp_relay_policy == null || can(regex("^[a-zA-Z0-9_.:-]{0,64}$", l.dhcp_relay_policy))
    ])
    error_message = "`dhcp_relay_policy`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for l in var.dhcp_labels : contains(["tenant", "infra"], l.scope)
    ])
    error_message = "`scope`: Allowed values: `tenant`, `infra`."
  }

  validation {
    condition = alltrue([
      for l in var.dhcp_labels : l.dhcp_option_policy == null || can(regex("^[a-zA-Z0-9_.:-]{0,64}$", l.dhcp_option_policy))
    ])
    error_message = "`dhcp_option_policy`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "endpoint_retention_policy" {
  description = "Endpoint Retention Policy."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.endpoint_retention_policy))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "netflow_monitor_policies" {
  description = "List of Netflow Monitor policies"
  type = list(object({
    name           = string
    ip_filter_type = optional(string, "ipv4")
  }))
  default = []

  validation {
    condition = alltrue([
      for l in var.netflow_monitor_policies : can(regex("^[a-zA-Z0-9_.:-]{0,64}$", l.name))
    ])
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
  validation {
    condition = alltrue([
      for l in var.netflow_monitor_policies : contains(["ipv4", "ipv6", "ce", "unspecified"], l.ip_filter_type)
    ])
    error_message = "`ip_filter_type`: Allowed values: `ipv4`, `ipv6`, `ce`, `unspecified`"
  }
}

variable "legacy_mode_vlan" {
  description = "Legacy Mode VLAN. Allowed values `vlan`: `1` - `4094`."
  type        = number
  default     = null

  validation {
    condition     = var.legacy_mode_vlan == null || try(var.legacy_mode_vlan >= 1 && var.legacy_mode_vlan <= 4094, false)
    error_message = "Allowed values: `1` - `4094`."
  }
}
