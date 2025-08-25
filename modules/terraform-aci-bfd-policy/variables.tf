variable "name" {
  description = "BFD policy name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.name))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "type" {
  description = "BFD policy type."
  type        = string

  validation {
    condition     = contains(["ipv4", "ipv6"], var.type)
    error_message = "Valid values are `ipv4` or `ipv6`."
  }
}

variable "description" {
  description = "BFD policy description."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9\\\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", var.description))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, }`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }
}

variable "detection_multiplier" {
  description = "Detection multiplier. Minimum value: 1. Maximum value: 50."
  type        = number
  default     = 3

  validation {
    condition     = var.detection_multiplier >= 1 && var.detection_multiplier <= 50
    error_message = "Minimum value: 1. Maximum value: 50."
  }
}

variable "min_rx_interval" {
  description = "Min RX interval. Minimum value: 50. Maximum value: 999."
  type        = number
  default     = 50

  validation {
    condition     = var.min_rx_interval >= 50 && var.min_rx_interval <= 999
    error_message = "Minimum value: 50. Maximum value: 999."
  }
}

variable "min_tx_interval" {
  description = "Min TX interval. Minimum value: 50. Maximum value: 999."
  type        = number
  default     = 50

  validation {
    condition     = var.min_tx_interval >= 50 && var.min_tx_interval <= 999
    error_message = "Minimum value: 50. Maximum value: 999."
  }
}

variable "slow_timer_interval" {
  description = "Slow timer interval. Minimum value: 1000. Maximum value: 30000."
  type        = number
  default     = 2000

  validation {
    condition     = var.slow_timer_interval >= 1000 && var.slow_timer_interval <= 30000
    error_message = "Minimum value: 1000. Maximum value: 30000."
  }
}

variable "startup_timer_interval" {
  description = "Startup timer interval. Minimum value: 0. Maximum value: 60."
  type        = number
  default     = null

  validation {
    condition     = var.startup_timer_interval == null ? true : var.startup_timer_interval >= 0 && var.startup_timer_interval <= 60
    error_message = "Minimum value: 0. Maximum value: 60."
  }
}

variable "echo_rx_interval" {
  description = "Echo rx interval. Minimum value: 0. Maximum value: 999."
  type        = number
  default     = 50

  validation {
    condition     = var.echo_rx_interval >= 0 && var.echo_rx_interval <= 999
    error_message = "Minimum value: 0. Maximum value: 999."
  }
}

variable "echo_frame_source_address" {
  description = "BFD Source Address for Echo frames."
  type        = string
  default     = "0.0.0.0"
}