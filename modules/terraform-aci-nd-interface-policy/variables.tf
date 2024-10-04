variable "tenant" {
  description = "Tenant name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.tenant))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}
variable "name" {
  description = "ND interface policy name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.name))
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

variable "controller_state" {
  description = "Controller administrative state."
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for state in var.controller_state : contains(["managed-cfg", "other-cfg", "suppress-ra", "suppress-ra-mtu", "unsolicit-na-glean"], state)
    ])
    error_message = "Allowed values are `managed-cfg`, `other-cfg`, `suppress-ra`, `suppress-ra-mtu`, or `unsolicit-na-glean`"
  }
}

variable "hop_limit" {
  description = "Detection multiplier. Minimum value: 0. Maximum value: 255."
  type        = number
  default     = 64

  validation {
    condition     = var.hop_limit >= 0 && var.hop_limit <= 255
    error_message = "Minimum value: 0. Maximum value: 255."
  }
}

variable "ns_tx_interval" {
  description = "Neighbor solicitation transmit interval (msec). Minimum value: 1000. Maximum value: 3600000."
  type        = number
  default     = 1000

  validation {
    condition     = var.ns_tx_interval >= 50 && var.ns_tx_interval <= 3600000
    error_message = "Minimum value: 1000. Maximum value: 360000."
  }
}

variable "mtu" {
  description = "Maximum transmission unit. Minimum value: 1280. Maximum value: 9000."
  type        = number
  default     = 9000

  validation {
    condition     = var.mtu >= 1280 && var.mtu <= 9000
    error_message = "Minimum value: 1280. Maximum value: 9000."
  }
}

variable "retransmit_retry_count" {
  description = "Retransmission retry count. Minimum value: 1. Maximum value: 100."
  type        = number
  default     = 3

  validation {
    condition     = var.retransmit_retry_count >= 1 && var.retransmit_retry_count <= 100
    error_message = "Minimum value: 1. Maximum value: 100."
  }
}

variable "nud_retransmit_base" {
  description = "NUD retransmission base. Minimum value: 1. Maximum value: 3."
  type        = number
  default     = 0

  validation {
    condition     = var.nud_retransmit_base == 0 || var.nud_retransmit_base >= 1 && var.nud_retransmit_base <= 3
    error_message = "Minimum value: 1. Maximum value: 3."
  }
}

variable "nud_retransmit_interval" {
  description = "NUD retransmission interval (msec). Minimum value: 1000. Maximum value: 10000."
  type        = number
  default     = 0

  validation {
    condition     = var.nud_retransmit_interval == 0 || var.nud_retransmit_interval >= 1000 && var.nud_retransmit_interval <= 10000
    error_message = "Minimum value: 1000. Maximum value: 10000."
  }
}

variable "nud_retransmit_count" {
  description = "NUD retransmission count. Minimum value: 3. Maximum value: 10."
  type        = number
  default     = 0

  validation {
    condition     = var.nud_retransmit_count == 0 || var.nud_retransmit_count >= 3 && var.nud_retransmit_count <= 10
    error_message = "Minimum value: 3. Maximum value: 10."
  }
}

variable "route_advertise_interval" {
  description = "Route advertise interval. Minimum value: 4. Maximum value: 1800."
  type        = number
  default     = 600

  validation {
    condition     = var.route_advertise_interval >= 4 && var.route_advertise_interval <= 1800
    error_message = "Minimum value: 4. Maximum value: 1800."
  }
}

variable "router_lifetime" {
  description = "Router lifetime. Minimum value: 0. Maximum value: 9000."
  type        = number
  default     = 1800

  validation {
    condition     = var.router_lifetime >= 0 && var.router_lifetime <= 9000
    error_message = "Minimum value: 0. Maximum value: 9000."
  }
}

variable "reachable_time" {
  description = "Reachable time (msec). Minimum value: 0. Maximum value: 3600000."
  type        = number
  default     = 0

  validation {
    condition     = var.reachable_time >= 0 && var.reachable_time <= 3600000
    error_message = "Minimum value: 0. Maximum value: 360000."
  }
}

variable "retransmit_timer" {
  description = "Retransmit timer (msec). Minimum value: 0. Maximum value: 4294967295."
  type        = number
  default     = 0

  validation {
    condition     = var.retransmit_timer >= 0 && var.retransmit_timer <= 4294967295
    error_message = "Minimum value: 0. Maximum value: 4294967295."
  }
}