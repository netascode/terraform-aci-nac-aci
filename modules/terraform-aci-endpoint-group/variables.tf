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
  description = "Endpoint group name."
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

variable "proxy_arp" {
  description = "Proxy-ARP"
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
    description           = optional(string, "")
    ip                    = string
    public                = optional(bool, false)
    shared                = optional(bool, false)
    igmp_querier          = optional(bool, false)
    nd_ra_prefix          = optional(bool, true)
    no_default_gateway    = optional(bool, false)
    nd_ra_prefix_policy   = optional(string, "")
    ip_dataplane_learning = optional(bool, null)
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
    u_segmentation       = optional(bool, false)
    delimiter            = optional(string, "")
    vlan                 = optional(number)
    primary_vlan         = optional(number)
    secondary_vlan       = optional(number)
    netflow              = optional(bool, false)
    deployment_immediacy = optional(string, "lazy")
    resolution_immediacy = optional(string, "immediate")
    allow_promiscuous    = optional(bool, false)
    forged_transmits     = optional(bool, false)
    mac_changes          = optional(bool, false)
    custom_epg_name      = optional(string, "")
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
      for dom in var.vmware_vmm_domains : dom.vlan == null || try(dom.vlan >= 1 && dom.vlan <= 4096, false)
    ])
    error_message = "`vlan`: Minimum value: `1`. Maximum value: `4096`."
  }

  validation {
    condition = alltrue([
      for dom in var.vmware_vmm_domains : dom.primary_vlan == null || try(dom.primary_vlan >= 1 && dom.primary_vlan <= 4096, false)
    ])
    error_message = "`primary_vlan`: Minimum value: `1`. Maximum value: `4096`."
  }

  validation {
    condition = alltrue([
      for dom in var.vmware_vmm_domains : dom.secondary_vlan == null || try(dom.secondary_vlan >= 1 && dom.secondary_vlan <= 4096, false)
    ])
    error_message = "`secondary_vlan`: Minimum value: `1`. Maximum value: `4096`."
  }

  validation {
    condition = alltrue([
      for dom in var.vmware_vmm_domains : dom.deployment_immediacy == null || try(contains(["immediate", "lazy"], dom.deployment_immediacy), false)
    ])
    error_message = "`deployment_immediacy`: Allowed values are `immediate` or `lazy`."
  }

  validation {
    condition = alltrue([
      for dom in var.vmware_vmm_domains : dom.resolution_immediacy == null || try(contains(["immediate", "lazy", "pre-provision"], dom.resolution_immediacy), false)
    ])
    error_message = "`resolution_immediacy`: Allowed values are `immediate`, `lazy` or `pre-provision`."
  }

  validation {
    condition = alltrue([
      for dom in var.vmware_vmm_domains : dom.custom_epg_name == null || can(regex("^.{0,80}$", dom.custom_epg_name))
    ])
    error_message = "`custom_epg_name`: Maximum characters: 80."
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
    pod_id               = optional(number, 1)
    node_id              = number
    vlan                 = number
    mode                 = optional(string, "regular")
    deployment_immediacy = optional(string, "immediate")
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

  validation {
    condition = alltrue([
      for sp in var.static_leafs : (sp.vlan >= 1 && sp.vlan <= 4096)
    ])
    error_message = "`vlan`: Minimum value: `1`. Maximum value: `4096`."
  }

  validation {
    condition = alltrue([
      for sp in var.static_leafs : sp.mode == null || try(contains(["regular", "native", "untagged"], sp.mode), false)
    ])
    error_message = "`mode`: Allowed values are `regular`, `native` or `untagged`."
  }

  validation {
    condition = alltrue([
      for sp in var.static_leafs : sp.deployment_immediacy == null || try(contains(["immediate", "lazy"], sp.deployment_immediacy), false)
    ])
    error_message = "`deployment_immediacy`: Allowed values are `immediate` or `lazy`."
  }
}

variable "static_ports" {
  description = "List of static ports. Allowed values `node_id`, `node2_id`: `1` - `4000`. Allowed values `fex_id`, `fex2_id`: `101` - `199`. Allowed values `vlan`: `1` - `4096`. Allowed values `pod_id`: `1` - `255`. Default value `pod_id`: `1`. Allowed values `port`: `1` - `127`. Allowed values `sub_port`: `1` - `16`. Allowed values `module`: `1` - `9`. Default value `module`: `1`. Choices `deployment_immediacy`: `immediate`, `lazy`. Default value `deployment_immediacy`: `lazy`. Choices `mode`: `regular`, `native`, `untagged`. Default value `mode`: `regular`."
  type = list(object({
    description          = optional(string, "")
    node_id              = number
    node2_id             = optional(number)
    fex_id               = optional(number)
    fex2_id              = optional(number)
    vlan                 = number
    primary_vlan         = optional(number)
    pod_id               = optional(number, 1)
    port                 = optional(number)
    sub_port             = optional(number)
    module               = optional(number, 1)
    channel              = optional(string)
    deployment_immediacy = optional(string, "lazy")
    mode                 = optional(string, "regular")
    ptp_source_ip        = optional(string, "0.0.0.0")
    ptp_mode             = optional(string, "multicast")
    ptp_profile          = optional(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for sp in var.static_ports : can(regex("^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$", sp.ptp_source_ip))
    ])
    error_message = "`ptp_source_ip` is not a valid IPv4 address."
  }

  validation {
    condition = alltrue([
      for sp in var.static_ports : try(contains(["multicast", "multicast-master", "unicast-master"], sp.ptp_mode), false)
    ])
    error_message = "`ptp_mode`: Allowed values are `multicast`, `multicast-master` or `unicast-master`."
  }

  validation {
    condition = alltrue([
      for sp in var.static_ports : sp.ptp_profile == null || can(regex("^[a-zA-Z0-9_.:-]{0,16}$", sp.ptp_profile))
    ])
    error_message = "`ptp_profile`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 16."
  }

  validation {
    condition = alltrue([
      for sp in var.static_ports : (sp.node_id >= 1 && sp.node_id <= 4000)
    ])
    error_message = "`node_id`: Minimum value: `1`. Maximum value: `4000`."
  }

  validation {
    condition = alltrue([
      for sp in var.static_ports : sp.node2_id == null || try(sp.node2_id >= 1 && sp.node2_id <= 4000, false)
    ])
    error_message = "`node2_id`: Minimum value: `1`. Maximum value: `4000`."
  }

  validation {
    condition = alltrue([
      for sp in var.static_ports : sp.fex_id == null || try(sp.fex_id >= 101 && sp.fex_id <= 199, false)
    ])
    error_message = "`fex_id`: Minimum value: `101`. Maximum value: `199`."
  }

  validation {
    condition = alltrue([
      for sp in var.static_ports : sp.fex2_id == null || try(sp.fex2_id >= 101 && sp.fex2_id <= 199, false)
    ])
    error_message = "`fex2_id`: Minimum value: `101`. Maximum value: `199`."
  }

  validation {
    condition = alltrue([
      for sp in var.static_ports : (sp.vlan >= 1 && sp.vlan <= 4096)
    ])
    error_message = "`vlan`: Minimum value: `1`. Maximum value: `4096`."
  }

  validation {
    condition = alltrue([
      for sp in var.static_ports : sp.primary_vlan == null || try(sp.primary_vlan >= 1 && sp.primary_vlan <= 4096, false)
    ])
    error_message = "`primary_vlan`: Minimum value: `1`. Maximum value: `4096`."
  }

  validation {
    condition = alltrue([
      for sp in var.static_ports : sp.pod_id == null || try(sp.pod_id >= 1 && sp.pod_id <= 255, false)
    ])
    error_message = "`pod_id`: Minimum value: `1`. Maximum value: `255`."
  }

  validation {
    condition = alltrue([
      for sp in var.static_ports : sp.port == null || try(sp.port >= 1 && sp.port <= 127, false)
    ])
    error_message = "`port`: Minimum value: `1`. Maximum value: `127`."
  }

  validation {
    condition = alltrue([
      for sp in var.static_ports : sp.sub_port == null || try(sp.sub_port >= 1 && sp.sub_port <= 16, false)
    ])
    error_message = "`sub_port`: Minimum value: `1`. Maximum value: `16`."
  }

  validation {
    condition = alltrue([
      for sp in var.static_ports : sp.module == null || try(sp.module >= 1 && sp.module <= 9, false)
    ])
    error_message = "`module`: Minimum value: `1`. Maximum value: `9`."
  }

  validation {
    condition = alltrue([
      for sp in var.static_ports : sp.channel == null || can(regex("^[a-zA-Z0-9_.:-]{0,64}$", sp.channel))
    ])
    error_message = "`channel`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`, `:`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for sp in var.static_ports : sp.deployment_immediacy == null || try(contains(["immediate", "lazy"], sp.deployment_immediacy), false)
    ])
    error_message = "`deployment_immediacy`: Allowed values are `immediate` or `lazy`."
  }

  validation {
    condition = alltrue([
      for sp in var.static_ports : sp.mode == null || try(contains(["regular", "native", "untagged"], sp.mode), false)
    ])
    error_message = "`mode`: Allowed values are `regular`, `native` or `untagged`."
  }
}

variable "static_endpoints" {
  description = "List of static endpoints. Format `mac`: `12:34:56:78:9A:BC`. Choices `type`: `silent-host`, `tep`, `vep`. Allowed values `node_id`, `node2_id`: `1` - `4000`. Allowed values `vlan`: `1` - `4096`. Allowed values `pod_id`: `1` - `255`. Default value `pod_id`: `1`. Allowed values `port`: `1` - `127`. Allowed values `module`: `1` - `9`. Default value `module`: `1`."
  type = list(object({
    name           = optional(string, "")
    alias          = optional(string, "")
    mac            = string
    ip             = optional(string, "0.0.0.0")
    type           = string
    node_id        = optional(number)
    node2_id       = optional(number)
    vlan           = optional(number)
    pod_id         = optional(number, 1)
    port           = optional(number)
    module         = optional(number, 1)
    channel        = optional(string)
    additional_ips = optional(list(string), [])
  }))
  default = []

  validation {
    condition = alltrue([
      for se in var.static_endpoints : can(regex("^[a-zA-Z0-9_.:-]{0,64}$", se.name))
    ])
    error_message = "`name`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for se in var.static_endpoints : se.alias == null || can(regex("^[a-zA-Z0-9_.:-]{0,64}$", se.alias))
    ])
    error_message = "`alias`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for se in var.static_endpoints : can(regex("^([0-9A-Fa-f]{2}[:]){5}([0-9A-Fa-f]{2})$", se.mac))
    ])
    error_message = "`mac`: Format: `12:34:56:78:9A:BC`."
  }

  validation {
    condition = alltrue([
      for se in var.static_endpoints : se.type == null || try(contains(["silent-host", "tep", "vep"], se.type), false)
    ])
    error_message = "`type`: Allowed values are `silent-host`, `tep` or `vep`."
  }

  validation {
    condition = alltrue([
      for se in var.static_endpoints : se.node_id == null || try(se.node_id >= 1 && se.node_id <= 4000, false)
    ])
    error_message = "`node_id`: Minimum value: `1`. Maximum value: `4000`."
  }

  validation {
    condition = alltrue([
      for se in var.static_endpoints : se.node2_id == null || try(se.node2_id >= 1 && se.node2_id <= 4000, false)
    ])
    error_message = "`node2_id`: Minimum value: `1`. Maximum value: `4000`."
  }

  validation {
    condition = alltrue([
      for se in var.static_endpoints : se.vlan == null || try(se.vlan >= 1 && se.vlan <= 4096, false)
    ])
    error_message = "`vlan`: Minimum value: `1`. Maximum value: `4096`."
  }

  validation {
    condition = alltrue([
      for se in var.static_endpoints : se.pod_id == null || try(se.pod_id >= 1 && se.pod_id <= 255, false)
    ])
    error_message = "`pod_id`: Minimum value: `1`. Maximum value: `255`."
  }

  validation {
    condition = alltrue([
      for se in var.static_endpoints : se.port == null || try(se.port >= 1 && se.port <= 127, false)
    ])
    error_message = "`port`: Minimum value: `1`. Maximum value: `127`."
  }

  validation {
    condition = alltrue([
      for se in var.static_endpoints : se.module == null || try(se.module >= 1 && se.module <= 9, false)
    ])
    error_message = "`module`: Minimum value: `1`. Maximum value: `9`."
  }

  validation {
    condition = alltrue([
      for se in var.static_endpoints : se.channel == null || can(regex("^[a-zA-Z0-9_.:-]{0,64}$", se.channel))
    ])
    error_message = "`channel`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "l4l7_virtual_ips" {
  description = "List of EPG L4/L7 Virtual IPs."
  type = list(object({
    ip          = string
    description = optional(string, "")
  }))
  default = []

  validation {
    condition = alltrue([
      for vip in var.l4l7_virtual_ips : can(regex("^[a-zA-Z0-9\\\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", vip.description))
    ])
    error_message = "`description`: Allowed characters:  `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, }`, `~`, `?`, `&`, `+`.. Maximum characters: 128."
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

variable "bulk_static_ports" {
  description = "Use bulk resource to configure static ports."
  type        = bool
  default     = false
}