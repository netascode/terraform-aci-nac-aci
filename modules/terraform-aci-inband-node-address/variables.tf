variable "node_id" {
  description = "Node ID."
  type        = number

  validation {
    condition     = var.node_id >= 1 && var.node_id <= 4000
    error_message = "Minimum value: 1. Maximum value: 4000."
  }
}

variable "pod_id" {
  description = "Pod ID."
  type        = number
  default     = 1

  validation {
    condition     = var.pod_id >= 0 && var.pod_id <= 255
    error_message = "Minimum value: 0. Maximum value: 255."
  }
}

variable "ip" {
  description = "Inband IP address."
  type        = string
  default     = "0.0.0.0"
}

variable "gateway" {
  description = "Inband gateway IP."
  type        = string
  default     = "0.0.0.0"
}

variable "v6_ip" {
  description = "Inband IPv6 address."
  type        = string
  default     = "::"
}

variable "v6_gateway" {
  description = "Inband IPv6 gateway IP."
  type        = string
  default     = "::"
}

variable "endpoint_group" {
  description = "Inband management endpoint group name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.endpoint_group))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "endpoint_group_vlan" {
  description = "Inband management endpoint group vlan."
  type        = number

  validation {
    condition     = var.endpoint_group_vlan >= 1 && var.endpoint_group_vlan <= 4094
    error_message = "Minimum value: 1. Maximum value: 4094."
  }
}
