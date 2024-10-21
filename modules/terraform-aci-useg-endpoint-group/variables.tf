variable "tenant" {
  description = "Tenant name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.tenant))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "application_profile" {
  description = "Application profile name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.application_profile))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "name" {
  description = "uSeg Endpoint group name."
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

variable "description" {
  description = "Description."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9\\\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", var.description))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, }`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }
}

variable "flood_in_encap" {
  description = "Flood in encapsulation."
  type        = bool
  default     = false
}

variable "intra_epg_isolation" {
  description = "Intra EPG isolation."
  type        = bool
  default     = false
}

variable "preferred_group" {
  description = "Preferred group membership."
  type        = bool
  default     = false
}

variable "qos_class" {
  description = "QoS class."
  type        = string
  default     = "unspecified"

  validation {
    condition     = can(contains(["level1", "level2", "level3", "level4", "level5", "level6", "unspecified"], var.qos_class))
    error_message = "Allowed values are `level1` to `level6` and `unspecified`."
  }
}

variable "custom_qos_policy" {
  description = "Custom QoS policy name."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.custom_qos_policy))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "bridge_domain" {
  description = "Bridge domain name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.bridge_domain))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "tags" {
  description = "List of EPG tags."
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for tag in var.tags : can(regex("^[a-zA-Z0-9_.-]{0,64}$", tag))
    ])
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "trust_control_policy" {
  description = "EPG Trust Control Policy Name."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.trust_control_policy))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "contract_consumers" {
  description = "List of contract consumers."
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for c in var.contract_consumers : can(regex("^[a-zA-Z0-9_.:-]{0,64}$", c))
    ])
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "contract_providers" {
  description = "List of contract providers."
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for c in var.contract_providers : can(regex("^[a-zA-Z0-9_.:-]{0,64}$", c))
    ])
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "contract_imported_consumers" {
  description = "List of imported contract consumers."
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for c in var.contract_imported_consumers : can(regex("^[a-zA-Z0-9_.:-]{0,64}$", c))
    ])
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "contract_intra_epgs" {
  description = "List of intra-EPG contracts."
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for c in var.contract_intra_epgs : can(regex("^[a-zA-Z0-9_.:-]{0,64}$", c))
    ])
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "contract_masters" {
  description = "List of EPG contract masters."
  type = list(object({
    endpoint_group      = string
    application_profile = optional(string, "")
  }))
  default = []

  validation {
    condition = alltrue([
      for master in var.contract_masters : can(regex("^[a-zA-Z0-9_.:-]{0,64}$", master.endpoint_group))
    ])
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for master in var.contract_masters : can(regex("^[a-zA-Z0-9_.:-]{0,64}$", master.application_profile))
    ])
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "physical_domains" {
  description = "List of physical domains."
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for pd in var.physical_domains : can(regex("^[a-zA-Z0-9_.:-]{0,64}$", pd))
    ])
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "subnets" {
  description = "List of subnets. Default value `public`: `false`. Default value `shared`: `false`. Default value `igmp_querier`: `false`. Default value `nd_ra_prefix`: `true`. Default value `no_default_gateway`: `false`. `nlb_mode` allowed values: `mode-mcast-igmp`, `mode-uc` or `mode-mcast-static`."
  type = list(object({
    description         = optional(string, "")
    ip                  = string
    public              = optional(bool, false)
    shared              = optional(bool, false)
    igmp_querier        = optional(bool, false)
    nd_ra_prefix        = optional(bool, true)
    no_default_gateway  = optional(bool, false)
    nd_ra_prefix_policy = optional(string, "")
    ip_pools = optional(list(object({
      name              = string
      start_ip          = optional(string, "0.0.0.0")
      end_ip            = optional(string, "0.0.0.0")
      dns_search_suffix = optional(string, "")
      dns_server        = optional(string, "")
      dns_suffix        = optional(string, "")
      wins_server       = optional(string, "")
    })), [])
    next_hop_ip = optional(string, "")
    anycast_mac = optional(string, "")
    nlb_group   = optional(string, "0.0.0.0")
    nlb_mac     = optional(string, "00:00:00:00:00:00")
    nlb_mode    = optional(string, "")
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
      for s in var.subnets : try(contains(["mode-mcast-igmp", "mode-uc", "mode-mcast-static", ""], s.nlb_mode), false)
    ])
    error_message = "`nlb_mode`: Allowed values: `mode-mcast-igmp`, `mode-uc` or `mode-mcast-static`."
  }
}

variable "vmware_vmm_domains" {
  description = "List of VMware VMM domains. Default value `u_segmentation`: `false`. Default value `netflow`: `false`. Choices `deployment_immediacy`: `immediate`, `lazy`. Default value `deployment_immediacy`: `lazy`. Choices `resolution_immediacy`: `immediate`, `lazy`, `pre-provision`. Default value `resolution_immediacy`: `immediate`. Default value `allow_promiscuous`: `false`. Default value `forged_transmits`: `false`. Default value `mac_changes`: `false`."
  type = list(object({
    name                 = string
    deployment_immediacy = optional(string, "immediate")
    netflow              = optional(bool, false)
    elag                 = optional(string, "")
    active_uplinks_order = optional(string, "")
    standby_uplinks      = optional(string, "")
  }))
  default = []

  validation {
    condition = alltrue([
      for dom in var.vmware_vmm_domains : can(regex("^[a-zA-Z0-9_.:-]{0,64}$", dom.name))
    ])
    error_message = "`name`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for dom in var.vmware_vmm_domains : dom.deployment_immediacy == null || try(contains(["immediate", "lazy"], dom.deployment_immediacy), false)
    ])
    error_message = "`deployment_immediacy`: Allowed values are `immediate` or `lazy`."
  }

  validation {
    condition = alltrue([
      for dom in var.vmware_vmm_domains : can(regex("^[a-zA-Z0-9_.:-]{0,64}$", dom.elag))
    ])
    error_message = "`elag`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "static_leafs" {
  description = "List of static leaf switches. Allowed values `pod_id`: `1` - `255`. Default value `pod_id`: `1`. Allowed values `node_id`: `1` - `4000`. Allowed values `vlan`: `1` - `4096`. Choices `mode`: `regular`, `native`, `untagged`. Default value `mode`: `regular`. Choices `deployment_immediacy`: `immediate`, `lazy`. Default value `deployment_immediacy`: `immediate`"
  type = list(object({
    pod_id  = optional(number, 1)
    node_id = number
  }))
  default = []


  validation {
    condition = alltrue([
      for sp in var.static_leafs : sp.pod_id == null || try(sp.pod_id >= 1 && sp.pod_id <= 255, false)
    ])
    error_message = "`pod_id`: Minimum value: `1`. Maximum value: `255`."
  }

  validation {
    condition = alltrue([
      for sp in var.static_leafs : (sp.node_id >= 1 && sp.node_id <= 4000)
    ])
    error_message = "`node_id`: Minimum value: `1`. Maximum value: `4000`."
  }
}

variable "match_type" {
  description = "Match type for IP type uSeg Attributes"
  type        = string
  default     = "any"

  validation {
    condition     = can(contains(["any", "all"], var.match_type))
    error_message = "`match_type`: Allowed values are `any` or `all`."
  }
}

variable "ip_statements" {
  description = "IP Statements for IP type uSeg Attributes"
  type = list(object({
    name           = string
    use_epg_subnet = bool
    ip             = optional(string, "")
  }))
  default = []

  validation {
    condition = alltrue([
      for ip_statement in var.ip_statements : can(regex("^[a-zA-Z0-9_.:-]{0,64}$", ip_statement.name))
    ])
    error_message = "`name`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for ip_statement in var.ip_statements : (ip_statement.use_epg_subnet) || (!ip_statement.use_epg_subnet && (ip_statement.ip != "" && ip_statement.ip != "0.0.0.0"))
    ])
    error_message = "`ip`: A valid IP or subnet must be specified when `use_epg_subnet` is `false`."
  }
}

variable "mac_statements" {
  description = "MAC Statements for MAC type uSeg Attributes"
  type = list(object({
    name = string
    mac  = string
  }))
  default = []

  validation {
    condition = alltrue([
      for mac_statement in var.mac_statements : can(regex("^[a-zA-Z0-9_.:-]{0,64}$", mac_statement.name))
    ])
    error_message = "`name`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for mac_statement in var.mac_statements : can(regex("^([0-9A-Fa-f]{2}[:]){5}([0-9A-Fa-f]{2})$", mac_statement.mac))
    ])
    error_message = "`mac`: Valid MAC Format: `XX:XX:XX:XX:XX:XX`."
  }
}

variable "l4l7_address_pools" {
  description = "List of EPG L4/L7 Address Pools."
  type = list(object({
    name            = string
    gateway_address = string
    from            = optional(string, "")
    to              = optional(string, "")
  }))
  default = []

  validation {
    condition = alltrue([
      for pool in var.l4l7_address_pools : can(regex("^[a-zA-Z0-9_.:-]{0,64}$", pool.name))
    ])
    error_message = "`name`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}
