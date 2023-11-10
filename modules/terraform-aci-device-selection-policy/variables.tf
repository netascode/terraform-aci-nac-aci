variable "tenant" {
  description = "Tenant name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.tenant))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "contract" {
  description = "Contract name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.contract))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "service_graph_template" {
  description = "Service graph template name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.service_graph_template))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "sgt_device_tenant" {
  description = "Device tenant name."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.sgt_device_tenant))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "sgt_device_name" {
  description = "Device name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.sgt_device_name))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
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

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.consumer_logical_interface))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "consumer_redirect_policy" {
  description = "Consumer redirect policy name."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.consumer_redirect_policy))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "consumer_redirect_policy_tenant" {
  description = "Consumer redirect policy tenant name."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.consumer_redirect_policy_tenant))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "consumer_bridge_domain" {
  description = "Consumer bridge domain name."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.consumer_bridge_domain))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "consumer_bridge_domain_tenant" {
  description = "Consumer bridge domain tenant name."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.consumer_bridge_domain_tenant))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "consumer_external_endpoint_group" {
  description = "Consumer external endpoint group name."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.consumer_external_endpoint_group))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "consumer_external_endpoint_group_tenant" {
  description = "Consumer external endpoint group tenant name."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.consumer_external_endpoint_group_tenant))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "consumer_external_endpoint_group_l3out" {
  description = "Consumer external endpoint group l3out name."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.consumer_external_endpoint_group_l3out))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
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
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.consumer_service_epg_policy))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "consumer_service_epg_policy_tenant" {
  description = "Consumer service EPG policy tenant name."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.consumer_service_epg_policy_tenant))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "consumer_custom_qos_policy" {
  description = "Consumer custome QoS policy name."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.consumer_custom_qos_policy))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
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

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.provider_logical_interface))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "provider_redirect_policy" {
  description = "Provider redirect policy name."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.provider_redirect_policy))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "provider_redirect_policy_tenant" {
  description = "Provider redirect policy tenant name."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.provider_redirect_policy_tenant))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "provider_bridge_domain" {
  description = "Provider bridge domain name."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.provider_bridge_domain))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "provider_bridge_domain_tenant" {
  description = "Provider bridge domain tenant name."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.provider_bridge_domain_tenant))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "provider_external_endpoint_group" {
  description = "Provider external endpoint group name."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.provider_external_endpoint_group))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "provider_external_endpoint_group_tenant" {
  description = "Provider external endpoint group tenant name."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.provider_external_endpoint_group_tenant))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "provider_external_endpoint_group_l3out" {
  description = "Provider external endpoint group l3out name."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.provider_external_endpoint_group_l3out))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
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
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.provider_service_epg_policy))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "provider_service_epg_policy_tenant" {
  description = "Provider service EPG policy tenant name."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.provider_service_epg_policy_tenant))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "provider_custom_qos_policy" {
  description = "Provider custome QoS policy name."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.provider_custom_qos_policy))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}
