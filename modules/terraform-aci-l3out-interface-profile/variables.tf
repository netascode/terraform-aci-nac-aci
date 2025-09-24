variable "tenant" {
  description = "Tenant name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.tenant))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "l3out" {
  description = "L3out name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.l3out))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "node_profile" {
  description = "Node profile name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.node_profile))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "name" {
  description = "Interface profile name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.name))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "description" {
  description = "Interface profile description."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9\\\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", var.description))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, }`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }
}

variable "bfd_policy" {
  description = "BFD policy name."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.bfd_policy))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "ospf_interface_profile_name" {
  description = "OSPF interface profile name."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.ospf_interface_profile_name))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "ospf_authentication_key" {
  description = "OSPF authentication key."
  type        = string
  default     = ""
  sensitive   = true
}

variable "ospf_authentication_key_id" {
  description = "OSPF authentication key ID."
  type        = number
  default     = 1

  validation {
    condition     = var.ospf_authentication_key_id >= 1 && var.ospf_authentication_key_id <= 255
    error_message = "Minimum value: 1. Maximum value: 255."
  }
}

variable "ospf_authentication_type" {
  description = "OSPF authentication type. Choices: `none`, `simple`, `md5`."
  type        = string
  default     = "none"

  validation {
    condition     = contains(["none", "simple", "md5"], var.ospf_authentication_type)
    error_message = "Allowed values are `none`, `simple` or `md5`."
  }
}

variable "ospf_interface_policy" {
  description = "OSPF interface policy name."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.ospf_interface_policy))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "eigrp_interface_profile_name" {
  description = "EIGRP interface profile name."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.eigrp_interface_profile_name))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "eigrp_keychain_policy" {
  description = "EIGRP keychain policy name."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.eigrp_keychain_policy))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "eigrp_interface_policy" {
  description = "EIGRP interface policy name."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.eigrp_interface_policy))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "pim_policy" {
  description = "PIM policy name."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.pim_policy))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "igmp_interface_policy" {
  description = "IGMP interface policy name."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.igmp_interface_policy))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "nd_interface_policy" {
  description = "ND interface policy."
  type        = string
  default     = ""
}

variable "qos_class" {
  description = "QoS class. Choices: `level1`, `level2`, `level3`, `level4`, `level5`, `level6`, `unspecified`."
  type        = string
  default     = "unspecified"

  validation {
    condition     = contains(["level1", "level2", "level3", "level4", "level5", "level6", "unspecified"], var.qos_class)
    error_message = "Allowed values are `level1`, `level2`, `level3`, `level4`, `level5`, `level6` or `unspecified`."
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

variable "interfaces" {
  description = "List of interfaces. Default value `svi`: false. Default value `floating_svi`: false. Choices `type`. `access`, `pc`, `vpc`. Default value `type`: `access`. Allowed values `vlan`: 1-4096. Format `mac`: `12:34:56:78:9A:BC`. `mtu`: Allowed values are `inherit` or a number between 576 and 9216. Allowed values `node_id`, `node2_id`: 1-4000. Allowed values `pod_id`: 1-255. Default value `pod_id`: 1. Allowed values `module`: 1-9. Default value `module`: 1. Allowed values `port`: 1-127. Default value `bgp_peers.bfd`: false. Allowed values `bgp_peers.ttl`: 1-255. Default value `bgp_peers.ttl`: 1. Allowed values `bgp_peers.weight`: 0-65535. Default value `bgp_peers.weight`: 0. Allowed values `bgp_peers.remote_as`: 0-4294967295."
  type = list(object({
    description          = optional(string, "")
    type                 = optional(string, "access")
    node_id              = number
    node2_id             = optional(number)
    pod_id               = optional(number, 1)
    module               = optional(number, 1)
    port                 = optional(number)
    sub_port             = optional(number)
    channel              = optional(string)
    ip                   = optional(string)
    svi                  = optional(bool, false)
    autostate            = optional(bool, false)
    floating_svi         = optional(bool, false)
    vlan                 = optional(number)
    mac                  = optional(string, "00:22:BD:F8:19:FF")
    mtu                  = optional(string, "inherit")
    mode                 = optional(string, "regular")
    ip_a                 = optional(string)
    ip_b                 = optional(string)
    ip_shared            = optional(string)
    ip_shared_dhcp_relay = optional(bool, null)
    lladdr               = optional(string, "::")
    scope                = optional(string, "local")
    multipod_direct      = optional(bool, false)
    bgp_peers = optional(list(object({
      ip                               = string
      remote_as                        = string
      description                      = optional(string, "")
      allow_self_as                    = optional(bool, false)
      as_override                      = optional(bool, false)
      disable_peer_as_check            = optional(bool, false)
      next_hop_self                    = optional(bool, false)
      send_community                   = optional(bool, false)
      send_ext_community               = optional(bool, false)
      password                         = optional(string)
      allowed_self_as_count            = optional(number, 3)
      bfd                              = optional(bool, false)
      disable_connected_check          = optional(bool, false)
      ttl                              = optional(number, 1)
      weight                           = optional(number, 0)
      remove_all_private_as            = optional(bool, false)
      remove_private_as                = optional(bool, false)
      replace_private_as_with_local_as = optional(bool, false)
      unicast_address_family           = optional(bool, true)
      multicast_address_family         = optional(bool, true)
      admin_state                      = optional(bool, true)
      local_as                         = optional(number)
      as_propagate                     = optional(string, "none")
      peer_prefix_policy               = optional(string)
      export_route_control             = optional(string)
      import_route_control             = optional(string)
    })), [])
    paths = optional(list(object({
      physical_domain   = optional(string)
      vmware_vmm_domain = optional(string)
      elag              = optional(string)
      floating_ip       = string
      vlan              = optional(string)
    })), [])
    micro_bfd_destination_ip = optional(string, "")
    micro_bfd_start_timer    = optional(number, 0)
  }))
  default = []

  validation {
    condition = alltrue([
      for i in var.interfaces : i.description == null || try(can(regex("^[a-zA-Z0-9\\\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", i.description)), false)
    ])
    error_message = "`description`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, }`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }

  validation {
    condition = alltrue([
      for i in var.interfaces : i.type == null || try(contains(["access", "pc", "vpc"], i.type), false)
    ])
    error_message = "`type`: Allowed values are `access`, `pc` or `vpc`."
  }

  validation {
    condition = alltrue([
      for i in var.interfaces : i.vlan == null || try(i.vlan >= 1 && i.vlan <= 4096, false)
    ])
    error_message = "`vlan`: Minimum value: `1`. Maximum value: `4096`."
  }

  validation {
    condition = alltrue([
      for i in var.interfaces : i.mac == null || try(can(regex("^([0-9A-Fa-f]{2}[:]){5}([0-9A-Fa-f]{2})$", i.mac)), false)
    ])
    error_message = "`mac`: Format: `12:34:56:78:9A:BC`."
  }

  validation {
    condition = alltrue([
      for i in var.interfaces : i.mtu == null || try(contains(["inherit"], i.mtu), false) || try(tonumber(i.mtu) >= 576 && tonumber(i.mtu) <= 9216, false)
    ])
    error_message = "`mtu`: Allowed values are `inherit` or a number between 576 and 9216."
  }

  validation {
    condition = alltrue([
      for i in var.interfaces : i.mode == null || try(contains(["regular", "untagged", "native"], i.mode), false)
    ])
    error_message = "`mode`: Allowed values are `regular`, `native` or `untagged`"
  }

  validation {
    condition = alltrue([
      for i in var.interfaces : (i.node_id >= 1 && i.node_id <= 4000)
    ])
    error_message = "`node_id`: Minimum value: `1`. Maximum value: `4000`."
  }

  validation {
    condition = alltrue([
      for i in var.interfaces : i.node2_id == null || try(i.node2_id >= 1 && i.node2_id <= 4000, false)
    ])
    error_message = "`node2_id`: Minimum value: `1`. Maximum value: `4000`."
  }

  validation {
    condition = alltrue([
      for i in var.interfaces : i.pod_id == null || try(i.pod_id >= 1 && i.pod_id <= 255, false)
    ])
    error_message = "`pod_id`: Minimum value: `1`. Maximum value: `255`."
  }

  validation {
    condition = alltrue([
      for i in var.interfaces : i.module == null || try(i.module >= 1 && i.module <= 9, false)
    ])
    error_message = "`module`: Minimum value: `1`. Maximum value: `9`."
  }

  validation {
    condition = alltrue([
      for i in var.interfaces : i.port == null || try(i.port >= 1 && i.port <= 127, false)
    ])
    error_message = "`port`: Minimum value: `1`. Maximum value: `127`."
  }

  validation {
    condition = alltrue([
      for i in var.interfaces : i.sub_port == null || try(i.sub_port >= 1 && i.sub_port <= 16, false)
    ])
    error_message = "`sub_port`: Minimum value: `1`. Maximum value: `16`."
  }

  validation {
    condition = alltrue([
      for i in var.interfaces : i.channel == null || try(can(regex("^[a-zA-Z0-9_.:-]{0,64}$", i.channel)), false)
    ])
    error_message = "`channel`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`, `:`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for i in var.interfaces : i.scope == null || try(contains(["local", "vrf"], i.scope), false)
    ])
    error_message = "`scope`: Allowed values are `local` or `vrf`"
  }

  validation {
    condition = alltrue(flatten([
      for i in var.interfaces : [for b in coalesce(i.bgp_peers, []) : b.remote_as >= 0 && b.remote_as <= 4294967295]
    ]))
    error_message = "`bgp_peers.remote_as`: Minimum value: `0`. Maximum value: `4294967295`."
  }

  validation {
    condition = alltrue(flatten([
      for i in var.interfaces : [for b in coalesce(i.bgp_peers, []) : b.description == null || try(can(regex("^[a-zA-Z0-9\\\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", b.description)), false)]
    ]))
    error_message = "`bgp_peers.description`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, }`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }

  validation {
    condition = alltrue(flatten([
      for i in var.interfaces : [for b in coalesce(i.bgp_peers, []) : try(b.allowed_self_as_count >= 1 && b.allowed_self_as_count <= 10, false)]
    ]))
    error_message = "`bgp_peers.allowed_self_as_count`: Minimum value: `1`. Maximum value: `10`."
  }

  validation {
    condition = alltrue(flatten([
      for i in var.interfaces : [for b in coalesce(i.bgp_peers, []) : try(b.ttl >= 1 && b.ttl <= 255, false)]
    ]))
    error_message = "`bgp_peers.ttl`: Minimum value: `1`. Maximum value: `255`."
  }

  validation {
    condition = alltrue(flatten([
      for i in var.interfaces : [for b in coalesce(i.bgp_peers, []) : try(b.weight >= 0 && b.weight <= 65535, false)]
    ]))
    error_message = "`bgp_peers.weight`: Minimum value: `0`. Maximum value: `65535`."
  }

  validation {
    condition = alltrue(flatten([
      for i in var.interfaces : [for b in coalesce(i.bgp_peers, []) : b.local_as == null || try(b.local_as >= 0 && b.local_as <= 4294967295, false)]
    ]))
    error_message = "`bgp_peers.local_as`: Minimum value: `0`. Maximum value: `4294967295`."
  }

  validation {
    condition = alltrue(flatten([
      for i in var.interfaces : [for b in coalesce(i.bgp_peers, []) : b.as_propagate == null || try(contains(["none", "no-prepend", "replace-as", "dual-as"], b.as_propagate), false)]
    ]))
    error_message = "`bgp_peers.as_propagate`: Allowed value are: `none`, `no-prepend`, `replace-as` or `dual-as`."
  }

  validation {
    condition = alltrue(flatten([
      for i in var.interfaces : [for p in coalesce(i.paths, []) : p.physical_domain == null || try(can(regex("^[a-zA-Z0-9_.:-]{0,64}$", p.physical_domain)))]
    ]))
    error_message = "`paths.physical_domain`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`, `:`. Maximum characters: 64."
  }

  validation {
    condition = alltrue(flatten([
      for i in var.interfaces : [for p in coalesce(i.paths, []) : p.vmware_vmm_domain == null || try(can(regex("^[a-zA-Z0-9_.:-]{0,64}$", p.vmware_vmm_domain)))]
    ]))
    error_message = "`paths.vmware_vmm_domain`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue(flatten([
      for i in var.interfaces : [for p in coalesce(i.paths, []) : p.elag == null || try(can(regex("^[a-zA-Z0-9_.:-]{0,64}$", p.elag)))]
    ]))
    error_message = "`paths.elag`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for i in var.interfaces : i.micro_bfd_start_timer == null || try(i.micro_bfd_start_timer == 0 || try(i.micro_bfd_start_timer >= 60 && i.micro_bfd_start_timer <= 3600, false), false)
    ])
    error_message = "`interfaces.micro_bfd_start_timer`: Minimum value: `60`. Maximum value: `3600`."
  }
}

variable "multipod" {
  description = "Multipod L3out flag."
  type        = bool
  default     = false
}

variable "remote_leaf" {
  description = "Remote leaf L3out flag."
  type        = bool
  default     = false
}

variable "sr_mpls" {
  description = "SR MPLS L3out flag."
  type        = bool
  default     = false
}

variable "transport_data_plane" {
  description = "Transport Data Plane. Allowed values: `sr_mpls`, `mpls`. Default value: `sr_mpls`."
  type        = string
  default     = "sr_mpls"

  validation {
    condition     = contains(["sr_mpls", "mpls"], var.transport_data_plane)
    error_message = "`transport_data_plane`: Allowed value are: `sr_mpls`, `mpls`."
  }
}

variable "dhcp_labels" {
  description = "List of DHCP labels"
  type = list(object({
    dhcp_relay_policy  = string
    dhcp_option_policy = optional(string)
    scope              = optional(string, "infra")
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
}
