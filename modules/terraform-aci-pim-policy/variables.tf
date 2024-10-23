variable "tenant" {
  description = "Tenant name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.tenant))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "name" {
  description = "PIM policy name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.name))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "auth_key" {
  description = "PIM policy authorization key."
  type        = string
  default     = null
  sensitive   = true
}

variable "auth_type" {
  description = "PIM policy authorization type. Allowed values are: `none` or `ah-md5`."
  type        = string
  default     = "none"

  validation {
    condition     = contains(["none", "ah-md5"], var.auth_type)
    error_message = "Allowed values are: `none` or `ah-md5`."
  }
}

variable "mcast_dom_boundary" {
  description = "PIM policy multicast domain boundary flag."
  type        = bool
  default     = false
}

variable "passive" {
  description = "PIM policy multicast passive flag."
  type        = bool
  default     = false
}

variable "strict_rfc" {
  description = "PIM policy Mmlticast strict RFC compliant flag."
  type        = bool
  default     = false
}

variable "designated_router_delay" {
  description = "PIM policy designated router delay (seconds)."
  type        = number
  default     = 3

  validation {
    condition     = var.designated_router_delay >= 1 && var.designated_router_delay <= 65535
    error_message = "Allowed values `1`-`65535`."
  }
}

variable "designated_router_priority" {
  description = "PIM policy multicast designated router priority."
  type        = number
  default     = 1

  validation {
    condition     = var.designated_router_priority >= 1 && var.designated_router_priority <= 4294967295
    error_message = "Allowed values `1`-`4294967295`."
  }
}

variable "hello_interval" {
  description = "PIM policy multicast hello interval (milliseconds)."
  type        = number
  default     = 30000

  validation {
    condition     = var.hello_interval >= 1 && var.hello_interval <= 18724286
    error_message = "Allowed values `1`-`18724286`."
  }
}

variable "join_prune_interval" {
  description = "PIM policy join prune interval (seconds)."
  type        = number
  default     = 60

  validation {
    condition     = var.join_prune_interval >= 60 && var.join_prune_interval <= 65520
    error_message = "Allowed values `60`-`65520`."
  }
}

variable "neighbor_filter_policy" {
  description = "PIM policy interface-level neighbor filter policy."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.neighbor_filter_policy))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "join_prune_filter_policy_out" {
  description = "PIM policy interface-level outbound join-prune filter policy."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.join_prune_filter_policy_out))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "join_prune_filter_policy_in" {
  description = "PIM policy interface-level inbound join-prune filter policy."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.join_prune_filter_policy_in))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}
