variable "name" {
  description = "Storm control policy name."
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

variable "action" {
  description = "Action. Choices: `drop`, `shutdown`."
  type        = string
  default     = "drop"

  validation {
    condition     = contains(["drop", "shutdown"], var.action)
    error_message = "Allowed values are `drop` or `shutdown`."
  }
}

variable "broadcast_burst_pps" {
  description = "Broadcast burst packets per second."
  type        = string
  default     = "unspecified"

  validation {
    condition     = try(contains(["unspecified"], var.broadcast_burst_pps), false) || try(tonumber(var.broadcast_burst_pps) >= 1 && tonumber(var.broadcast_burst_pps) <= 4882812, false)
    error_message = "Allowed values are `unspecified` or a number between 1 and 4882812."
  }
}

variable "broadcast_burst_rate" {
  description = "Broadcast burst rate."
  type        = string
  default     = "100.000000"

  validation {
    condition     = try(contains(["defaultValue"], var.broadcast_burst_rate), false) || try(tonumber(var.broadcast_burst_rate) >= 0 && tonumber(var.broadcast_burst_rate) <= 100, false)
    error_message = "Allowed values are `defaultValue` or a number between 1 and 100."
  }
}

variable "broadcast_pps" {
  description = "Broadcast packets per second."
  type        = string
  default     = "unspecified"

  validation {
    condition     = try(contains(["unspecified"], var.broadcast_pps), false) || try(tonumber(var.broadcast_pps) >= 1 && tonumber(var.broadcast_pps) <= 4882812, false)
    error_message = "Allowed values are `unspecified` or a number between 1 and 4882812."
  }
}

variable "broadcast_rate" {
  description = "Broadcast rate."
  type        = string
  default     = "100.000000"

  validation {
    condition     = try(contains(["defaultValue"], var.broadcast_rate), false) || try(tonumber(var.broadcast_rate) >= 0 && tonumber(var.broadcast_rate) <= 100, false)
    error_message = "Allowed values are `defaultValue` or a number between 1 and 100."
  }
}

variable "multicast_burst_pps" {
  description = "Multicast burst packets per second."
  type        = string
  default     = "unspecified"

  validation {
    condition     = try(contains(["unspecified"], var.multicast_burst_pps), false) || try(tonumber(var.multicast_burst_pps) >= 1 && tonumber(var.multicast_burst_pps) <= 4882812, false)
    error_message = "Allowed values are `unspecified` or a number between 1 and 4882812."
  }
}

variable "multicast_burst_rate" {
  description = "Multicast burst rate."
  type        = string
  default     = "100.000000"

  validation {
    condition     = try(contains(["defaultValue"], var.multicast_burst_rate), false) || try(tonumber(var.multicast_burst_rate) >= 0 && tonumber(var.multicast_burst_rate) <= 100, false)
    error_message = "Allowed values are `defaultValue` or a number between 1 and 100."
  }
}

variable "multicast_pps" {
  description = "Multicast packets per second."
  type        = string
  default     = "unspecified"

  validation {
    condition     = try(contains(["unspecified"], var.multicast_pps), false) || try(tonumber(var.multicast_pps) >= 1 && tonumber(var.multicast_pps) <= 4882812, false)
    error_message = "Allowed values are `unspecified` or a number between 1 and 4882812."
  }
}

variable "multicast_rate" {
  description = "Multicast rate."
  type        = string
  default     = "100.000000"

  validation {
    condition     = try(contains(["defaultValue"], var.multicast_rate), false) || try(tonumber(var.multicast_rate) >= 0 && tonumber(var.multicast_rate) <= 100, false)
    error_message = "Allowed values are `defaultValue` or a number between 1 and 100."
  }
}

variable "unknown_unicast_burst_pps" {
  description = "Unknown unicast burst packets per second."
  type        = string
  default     = "unspecified"

  validation {
    condition     = try(contains(["unspecified"], var.unknown_unicast_burst_pps), false) || try(tonumber(var.unknown_unicast_burst_pps) >= 1 && tonumber(var.unknown_unicast_burst_pps) <= 4882812, false)
    error_message = "Allowed values are `unspecified` or a number between 1 and 4882812."
  }
}

variable "unknown_unicast_burst_rate" {
  description = "Unknown unicast burst rate."
  type        = string
  default     = "100.000000"

  validation {
    condition     = try(contains(["defaultValue"], var.unknown_unicast_burst_rate), false) || try(tonumber(var.unknown_unicast_burst_rate) >= 0 && tonumber(var.unknown_unicast_burst_rate) <= 100, false)
    error_message = "Allowed values are `defaultValue` or a number between 1 and 100."
  }
}

variable "unknown_unicast_pps" {
  description = "Unknown unicast packets per second."
  type        = string
  default     = "unspecified"

  validation {
    condition     = try(contains(["unspecified"], var.unknown_unicast_pps), false) || try(tonumber(var.unknown_unicast_pps) >= 1 && tonumber(var.unknown_unicast_pps) <= 4882812, false)
    error_message = "Allowed values are `unspecified` or a number between 1 and 4882812."
  }
}

variable "unknown_unicast_rate" {
  description = "Unknown unicast rate."
  type        = string
  default     = "100.000000"

  validation {
    condition     = try(contains(["defaultValue"], var.unknown_unicast_rate), false) || try(tonumber(var.unknown_unicast_rate) >= 0 && tonumber(var.unknown_unicast_rate) <= 100, false)
    error_message = "Allowed values are `defaultValue` or a number between 1 and 100."
  }
}

variable "burst_pps" {
  description = "Burst packets per second for all types of traffic."
  type        = string
  default     = "unspecified"

  validation {
    condition     = try(contains(["unspecified"], var.burst_pps), false) || try(tonumber(var.burst_pps) >= 1 && tonumber(var.burst_pps) <= 4882812, false)
    error_message = "Allowed values are `unspecified` or a number between 1 and 4882812."
  }
}

variable "burst_rate" {
  description = "Burst rate for all types of traffic."
  type        = string
  default     = "100.000000"

  validation {
    condition     = try(contains(["defaultValue"], var.burst_rate), false) || try(tonumber(var.burst_rate) >= 0 && tonumber(var.burst_rate) <= 100, false)
    error_message = "Allowed values are `defaultValue` or a number between 1 and 100."
  }
}

variable "rate_pps" {
  description = "Rate in packets per second for all types of traffic."
  type        = string
  default     = "unspecified"

  validation {
    condition     = try(contains(["unspecified"], var.rate_pps), false) || try(tonumber(var.rate_pps) >= 1 && tonumber(var.rate_pps) <= 4882812, false)
    error_message = "Allowed values are `unspecified` or a number between 1 and 4882812."
  }
}

variable "rate" {
  description = "Rate for all types of traffic."
  type        = string
  default     = "100.000000"

  validation {
    condition     = try(contains(["defaultValue"], var.rate), false) || try(tonumber(var.rate) >= 0 && tonumber(var.rate) <= 100, false)
    error_message = "Allowed values are `defaultValue` or a number between 1 and 100."
  }
}

variable "configuration_type" {
  description = "Storm control configuration type."
  type        = string
  default     = "separate"

  validation {
    condition     = try(contains(["separate", "all"], var.configuration_type), false)
    error_message = "Allowed values are `separete` or `all`."
  }
}