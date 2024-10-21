variable "name" {
  description = "VMware VMM domain name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.name))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "access_mode" {
  description = "Access mode. Choices: `read-only`, `read-write`."
  type        = string
  default     = "read-write"

  validation {
    condition     = contains(["read-only", "read-write"], var.access_mode)
    error_message = "Allowed values are `read-only` or `read-write`."
  }
}

variable "delimiter" {
  description = "Delimiter (vCenter Port Group)."
  type        = string
  default     = ""

  validation {
    condition     = var.delimiter == "" || can(regex("^[|~!@^+=]$", var.delimiter))
    error_message = "Allowed characters: `|`, `~`, `!`, `@`, `^`, `+`, `=`. Maximum characters: 1."
  }
}

variable "tag_collection" {
  description = "Tag collection."
  type        = bool
  default     = false
}

variable "vlan_pool" {
  description = "Vlan pool name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.vlan_pool))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "allocation" {
  description = "Vlan pool allocation mode. Choices: `static`, `dynamic`."
  type        = string
  default     = "dynamic"

  validation {
    condition     = contains(["static", "dynamic"], var.allocation)
    error_message = "Allowed values are `static` or `dynamic`."
  }
}

variable "vswitch_cdp_policy" {
  description = "vSwitch CDP policy name."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.vswitch_cdp_policy))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "vswitch_lldp_policy" {
  description = "vSwitch LLDP policy name."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.vswitch_lldp_policy))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "vswitch_port_channel_policy" {
  description = "vSwitch port channel policy name."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.vswitch_port_channel_policy))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "vswitch_mtu_policy" {
  description = "vSwitch MTU policy name."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.vswitch_mtu_policy))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "vswitch_netflow_policy" {
  description = "vSwitch NetFlow Exporter policy name."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.vswitch_netflow_policy))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "vswitch_enhanced_lags" {
  description = "vSwitch enhanced lags. Allowed values for `lb_mode`: `dst-ip`, `dst-ip-l4port`, `dst-ip-vlan`, `dst-ip-l4port-vlan`, `dst-mac`, `dst-l4port`, `src-ip`, `src-ip-l4port`, `src-ip-vlan`, `src-ip-l4port-vlan`, `src-mac`, `src-l4port`, `src-dst-ip`, `src-dst-ip-l4port`, `src-dst-ip-vlan`, `src-dst-ip-l4port-vlan`, `src-dst-mac`, `src-dst-l4port`, `src-port-id` or `vlan`. Default value: `src-dst-ip`. Allowed values for `mode`: `active` or `passive`. Defautl value: `active`. Allowed range for `num_links`: 2-8."
  type = list(object({
    name      = string
    lb_mode   = optional(string, "src-dst-ip")
    mode      = optional(string, "active")
    num_links = optional(number, 2)
  }))
  default = []

  validation {
    condition = alltrue([
      for elag in var.vswitch_enhanced_lags : can(regex("^[a-zA-Z0-9_.:-]{0,16}$", elag.name))
    ])
    error_message = "Allowed characters `name`: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 16."
  }

  validation {
    condition = alltrue([
      for elag in var.vswitch_enhanced_lags : contains(["dst-ip", "dst-ip-l4port", "dst-ip-vlan", "dst-ip-l4port-vlan", "dst-mac", "dst-l4port", "src-ip", "src-ip-l4port", "src-ip-vlan", "src-ip-l4port-vlan", "src-mac", "src-l4port", "src-dst-ip", "src-dst-ip-l4port", "src-dst-ip-vlan", "src-dst-ip-l4port-vlan", "src-dst-mac", "src-dst-l4port", "src-port-id", "vlan"], elag.lb_mode)
    ])
    error_message = "Allowed values for `lb_mode`: `dst-ip`, `dst-ip-l4port`, `dst-ip-vlan`, `dst-ip-l4port-vlan`, `dst-mac`, `dst-l4port`, `src-ip`, `src-ip-l4port`, `src-ip-vlan`, `src-ip-l4port-vlan`, `src-mac`, `src-l4port`, `src-dst-ip`, `src-dst-ip-l4port`, `src-dst-ip-vlan`, `src-dst-ip-l4port-vlan`, `src-dst-mac`, `src-dst-l4port`, `src-port-id` or `vlan`."
  }

  validation {
    condition = alltrue([
      for elag in var.vswitch_enhanced_lags : contains(["active", "passive"], elag.mode)
    ])
    error_message = "Allowed values for `mode`: `active`, `passive`."
  }

  validation {
    condition = alltrue([
      for elag in var.vswitch_enhanced_lags : elag.num_links >= 2 && elag.num_links <= 8
    ])
    error_message = "Allowed range for `num_links`: 2-8."
  }
}

variable "vcenters" {
  description = "List of vCenter hosts. Choices `dvs_version`: `unmanaged`, `5.1`, `5.5`, `6.0`, `6.5`, `6.6`, `7.0`. Default value `dvs_version`: `unmanaged`. Default value `statistics`: false. Allowed values `mgmt_epg_type`: `inb`, `oob`. Default value `mgmt_epg_type`: `inb`."
  type = list(object({
    name              = string
    hostname_ip       = string
    datacenter        = string
    credential_policy = optional(string)
    dvs_version       = optional(string, "unmanaged")
    statistics        = optional(bool, false)
    mgmt_epg_type     = optional(string, "inb")
    mgmt_epg_name     = optional(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for v in var.vcenters : can(regex("^[a-zA-Z0-9_.:-]{0,64}$", v.name))
    ])
    error_message = "Allowed characters `name`: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for v in var.vcenters : can(regex("^[a-zA-Z0-9:][a-zA-Z0-9.:-]{0,254}$", v.hostname_ip))
    ])
    error_message = "Allowed characters `hostname_ip`: `a`-`z`, `A`-`Z`, `0`-`9`, `.`, `:`, `-`. Maximum characters: 254."
  }

  validation {
    condition = alltrue([
      for v in var.vcenters : can(regex("^.{0,512}$", v.datacenter))
    ])
    error_message = "Maximum characters `datacenter`: 512."
  }

  validation {
    condition = alltrue([
      for v in var.vcenters : can(regex("^[a-zA-Z0-9_.:-]{0,64}$", v.credential_policy))
    ])
    error_message = "Allowed characters `credential_policy`: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for v in var.vcenters : v.dvs_version == null || try(contains(["unmanaged", "5.1", "5.5", "6.0", "6.5", "6.6", "7.0"], v.dvs_version), false)
    ])
    error_message = "`dvs_version`: Allowed values are `unmanaged`, `5.1`, `5.5`, `6.0`, `6.5`, `6.6` or `7.0`."
  }

  validation {
    condition = alltrue([
      for v in var.vcenters : v.mgmt_epg_type == null || try(contains(["inb", "oob"], v.mgmt_epg_type), false)
    ])
    error_message = "`mgmt_epg_type`: Allowed values are `inb` or `oob`."
  }

  validation {
    condition = alltrue([
      for v in var.vcenters : v.mgmt_epg_name == null || can(regex("^[a-zA-Z0-9_.:-]{0,64}$", v.mgmt_epg_name))
    ])
    error_message = "Allowed characters `mgmt_epg_name`: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "credential_policies" {
  description = "List of vCenter credentials."
  type = list(object({
    name     = string
    username = string
    password = string
  }))
  default = []

  validation {
    condition = alltrue([
      for c in var.credential_policies : can(regex("^[a-zA-Z0-9_.:-]{0,64}$", c.name))
    ])
    error_message = "Allowed characters `name`: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for c in var.credential_policies : can(regex("^[a-zA-Z0-9\\\\\\!#$%()*,-./:;@ _{|}~?&+]{1,128}$", c.username))
    ])
    error_message = "Allowed characters `username`: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, `_`, `{`, `|`, `}`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }
}


variable "uplinks" {
  description = "List of vSwitch uplinks. Allowed range for `id`: 1-32."
  type = list(object({
    id   = number
    name = string
  }))
  default = []

  validation {
    condition = alltrue([
      for uplink in var.uplinks : can(regex("^[a-zA-Z0-9_.:-]{0,64}$", uplink.name))
    ])
    error_message = "Allowed characters `name`: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for uplink in var.uplinks : can(regex("^[a-zA-Z0-9_.:-]{0,64}$", uplink.id))
    ])
    error_message = "Allowed range for `id`: 1-32."
  }
}

variable "security_domains" {
  description = "Security domains associated to VMware VMM domain"
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for s in var.security_domains : can(regex("^[a-zA-Z0-9_.:-]{0,64}$", s))
    ])
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}
