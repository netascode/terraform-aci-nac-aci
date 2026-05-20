variable "tenant" {
  description = "Tenant name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.tenant))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "contract" {
  description = "Contract name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.contract))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "service_graph_template" {
  description = "Service graph template name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.service_graph_template))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "sgt_device_tenant" {
  description = "Device tenant name."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.sgt_device_tenant))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "sgt_device_name" {
  description = "Device name. Required for legacy single-device mode, not used when `devices` is specified."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.sgt_device_name))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "node_name" {
  description = "Function node name."
  type        = string
  default     = "N1"

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.node_name))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "consumer_l3_destination" {
  description = "Consumer L3 destination."
  type        = bool
  default     = false
}

variable "consumer_permit_logging" {
  description = "Consumer permit logging."
  type        = bool
  default     = false
}

variable "consumer_logical_interface" {
  description = "Consumer logical interface."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.consumer_logical_interface))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "consumer_redirect_policy" {
  description = "Consumer redirect policy name."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.consumer_redirect_policy))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "consumer_redirect_policy_tenant" {
  description = "Consumer redirect policy tenant name."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.consumer_redirect_policy_tenant))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "consumer_bridge_domain" {
  description = "Consumer bridge domain name."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.consumer_bridge_domain))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "consumer_bridge_domain_tenant" {
  description = "Consumer bridge domain tenant name."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.consumer_bridge_domain_tenant))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "consumer_external_endpoint_group" {
  description = "Consumer external endpoint group name."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.consumer_external_endpoint_group))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "consumer_external_endpoint_group_tenant" {
  description = "Consumer external endpoint group tenant name."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.consumer_external_endpoint_group_tenant))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "consumer_external_endpoint_group_l3out" {
  description = "Consumer external endpoint group l3out name."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.consumer_external_endpoint_group_l3out))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "consumer_external_endpoint_group_redistribute_bgp" {
  description = "Consumer external endpoint group redistribute BGP."
  type        = bool
  default     = false
}

variable "consumer_external_endpoint_group_redistribute_ospf" {
  description = "Consumer external endpoint group redistribute OSPF."
  type        = bool
  default     = false
}

variable "consumer_external_endpoint_group_redistribute_connected" {
  description = "Consumer external endpoint group redistribute connected."
  type        = bool
  default     = false
}

variable "consumer_external_endpoint_group_redistribute_static" {
  description = "Consumer external endpoint group redistribute static."
  type        = bool
  default     = false
}

variable "consumer_service_epg_policy" {
  description = "Consumer service EPG policy name."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.consumer_service_epg_policy))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "consumer_service_epg_policy_tenant" {
  description = "Consumer service EPG policy tenant name."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.consumer_service_epg_policy_tenant))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "consumer_custom_qos_policy" {
  description = "Consumer custome QoS policy name."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.consumer_custom_qos_policy))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "provider_l3_destination" {
  description = "Provider L3 destination."
  type        = bool
  default     = false
}

variable "provider_permit_logging" {
  description = "Provider permit logging."
  type        = bool
  default     = false
}

variable "provider_logical_interface" {
  description = "Provider logical interface."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.provider_logical_interface))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "provider_redirect_policy" {
  description = "Provider redirect policy name."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.provider_redirect_policy))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "provider_redirect_policy_tenant" {
  description = "Provider redirect policy tenant name."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.provider_redirect_policy_tenant))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "provider_bridge_domain" {
  description = "Provider bridge domain name."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.provider_bridge_domain))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "provider_bridge_domain_tenant" {
  description = "Provider bridge domain tenant name."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.provider_bridge_domain_tenant))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "provider_external_endpoint_group" {
  description = "Provider external endpoint group name."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.provider_external_endpoint_group))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "provider_external_endpoint_group_tenant" {
  description = "Provider external endpoint group tenant name."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.provider_external_endpoint_group_tenant))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "provider_external_endpoint_group_l3out" {
  description = "Provider external endpoint group l3out name."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.provider_external_endpoint_group_l3out))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "provider_external_endpoint_group_redistribute_bgp" {
  description = "Provider external endpoint group redistribute BGP."
  type        = bool
  default     = false
}

variable "provider_external_endpoint_group_redistribute_ospf" {
  description = "Provider external endpoint group redistribute OSPF."
  type        = bool
  default     = false
}

variable "provider_external_endpoint_group_redistribute_connected" {
  description = "Provider external endpoint group redistribute connected."
  type        = bool
  default     = false
}

variable "provider_external_endpoint_group_redistribute_static" {
  description = "Provider external endpoint group redistribute static."
  type        = bool
  default     = false
}

variable "provider_service_epg_policy" {
  description = "Provider service EPG policy name."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.provider_service_epg_policy))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "provider_service_epg_policy_tenant" {
  description = "Provider service EPG policy tenant name."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.provider_service_epg_policy_tenant))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "provider_custom_qos_policy" {
  description = "Provider custom QoS policy name."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.provider_custom_qos_policy))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}


variable "copy_l3_destination" {
  description = "Copy L3 destination."
  type        = bool
  default     = false
}

variable "copy_permit_logging" {
  description = "Copy permit logging."
  type        = bool
  default     = false
}

variable "copy_logical_interface" {
  description = "Copy logical interface."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.copy_logical_interface))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "copy_custom_qos_policy" {
  description = "Copy custom QoS policy name."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.copy_custom_qos_policy))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "copy_service_epg_policy" {
  description = "Copy service EPG policy name."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.copy_service_epg_policy))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "copy_service_epg_policy_tenant" {
  description = "Copy service EPG policy tenant name."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.copy_service_epg_policy_tenant))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "devices" {
  description = "List of devices for multi-device device selection policy. When specified, legacy single-device variables (device_name, node_name, consumer, provider, copy_service at root level) are ignored."
  type = list(object({
    name      = string
    tenant    = optional(string)
    node_name = optional(string)
    consumer = optional(object({
      l3_destination    = optional(bool)
      permit_logging    = optional(bool)
      logical_interface = string
      redirect_policy = optional(object({
        name   = string
        tenant = optional(string)
      }))
      bridge_domain = optional(object({
        name   = string
        tenant = optional(string)
      }))
      external_endpoint_group = optional(object({
        tenant = optional(string)
        l3out  = string
        name   = string
        redistribute = optional(object({
          bgp       = optional(bool)
          ospf      = optional(bool)
          connected = optional(bool)
          static    = optional(bool)
        }))
      }))
      service_epg_policy = optional(string)
      custom_qos_policy  = optional(string)
    }))
    provider = optional(object({
      l3_destination    = optional(bool)
      permit_logging    = optional(bool)
      logical_interface = string
      redirect_policy = optional(object({
        name   = string
        tenant = optional(string)
      }))
      bridge_domain = optional(object({
        name   = string
        tenant = optional(string)
      }))
      external_endpoint_group = optional(object({
        tenant = optional(string)
        l3out  = string
        name   = string
        redistribute = optional(object({
          bgp       = optional(bool)
          ospf      = optional(bool)
          connected = optional(bool)
          static    = optional(bool)
        }))
      }))
      service_epg_policy = optional(string)
      custom_qos_policy  = optional(string)
    }))
    copy_service = optional(object({
      l3_destination     = optional(bool)
      permit_logging     = optional(bool)
      logical_interface  = string
      service_epg_policy = optional(string)
      custom_qos_policy  = optional(string)
    }))
  }))
  default = []

  validation {
    condition = alltrue([
      for device in var.devices : can(regex("^[a-zA-Z0-9_.:-]{1,64}$", device.name))
    ])
    error_message = "Device name must match: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. 1-64 characters."
  }

  validation {
    condition = alltrue([
      for device in var.devices : device.node_name == null || can(regex("^[a-zA-Z0-9_.:-]{1,64}$", device.node_name))
    ])
    error_message = "Device node_name must match: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. 1-64 characters."
  }
}
