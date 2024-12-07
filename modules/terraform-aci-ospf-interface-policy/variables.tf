variable "tenant" {
  description = "Tenant name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.tenant))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "name" {
  description = "OSPF interface policy name."
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

variable "cost" {
  description = "Interface cost. Allowed values are `unspecified` or a number between 0 and 65535."
  type        = string
  default     = "unspecified"

  validation {
    condition     = try(contains(["unspecified"], var.cost), false) || try(tonumber(var.cost) >= 0 && tonumber(var.cost) <= 65535, false)
    error_message = "Allowed values are `unspecified` or a number between 0 and 65535."
  }
}

variable "dead_interval" {
  description = "Dead interval. Minimum value: `1`. Maximum value: `65535`."
  type        = number
  default     = 40

  validation {
    condition     = var.dead_interval >= 1 && var.dead_interval <= 65535
    error_message = "Minimum value: `1`. Maximum value: `65535`."
  }
}

variable "hello_interval" {
  description = "Hello interval. Minimum value: `1`. Maximum value: `65535`."
  type        = number
  default     = 10

  validation {
    condition     = var.hello_interval >= 1 && var.hello_interval <= 65535
    error_message = "Minimum value: `1`. Maximum value: `65535`."
  }
}

variable "network_type" {
  description = "Network type. Choices: `bcast`, `p2p`."
  type        = string
  default     = "bcast"

  validation {
    condition     = contains(["bcast", "p2p"], var.network_type)
    error_message = "Allowed values are `bcast` or `p2p`."
  }
}

variable "priority" {
  description = "Priority. Minimum value: `0`. Maximum value: `255`."
  type        = number
  default     = 1

  validation {
    condition     = var.priority >= 0 && var.priority <= 255
    error_message = "Minimum value: `0`. Maximum value: `255`."
  }
}

variable "lsa_retransmit_interval" {
  description = "LSA retransmit interval. Minimum value: `1`. Maximum value: `65535`."
  type        = number
  default     = 5

  validation {
    condition     = var.lsa_retransmit_interval >= 1 && var.lsa_retransmit_interval <= 65535
    error_message = "Minimum value: `1`. Maximum value: `65535`."
  }
}

variable "lsa_transmit_delay" {
  description = "LSA transmit delay. Minimum value: `1`. Maximum value: `450`."
  type        = number
  default     = 1

  validation {
    condition     = var.lsa_transmit_delay >= 1 && var.lsa_transmit_delay <= 450
    error_message = "Minimum value: `1`. Maximum value: `450`."
  }
}

variable "passive_interface" {
  description = "Passive interface."
  type        = bool
  default     = false
}

variable "mtu_ignore" {
  description = "MTU ignore."
  type        = bool
  default     = false
}

variable "advertise_subnet" {
  description = "Advertise subnet."
  type        = bool
  default     = false
}

variable "bfd" {
  description = "BFD."
  type        = bool
  default     = false
}
