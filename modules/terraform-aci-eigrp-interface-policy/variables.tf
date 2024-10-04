variable "tenant" {
  description = "Tenant name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.tenant))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "name" {
  description = "EIGRP interface policy name."
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

variable "hold_interval" {
  description = "Hold interval. Minimum value: `1`. Maximum value: `65535`."
  type        = number
  default     = 15

  validation {
    condition     = var.hold_interval >= 1 && var.hold_interval <= 65535
    error_message = "Minimum value: `1`. Maximum value: `65535`."
  }
}

variable "hello_interval" {
  description = "Hello interval. Minimum value: `1`. Maximum value: `65535`."
  type        = number
  default     = 5

  validation {
    condition     = var.hello_interval >= 1 && var.hello_interval <= 65535
    error_message = "Minimum value: `1`. Maximum value: `65535`."
  }
}

variable "bandwidth" {
  description = "Bandwidth. Minimum value: `0`. Maximum value: `256000000`."
  type        = number
  default     = 1

  validation {
    condition     = var.bandwidth >= 0 && var.bandwidth <= 256000000
    error_message = "Minimum value: `0`. Maximum value: `256000000`."
  }
}

variable "delay" {
  description = "Delay. Minimum value: `0`. Maximum value: `4294967295`."
  type        = number
  default     = 1

  validation {
    condition     = var.delay >= 0 && var.delay <= 4294967295
    error_message = "Minimum value: `0`. Maximum value: `4294967295`."
  }
}

variable "delay_unit" {
  description = "Delay Unit. Choices: `tens-of-micro`, `pico`."
  type        = string
  default     = "tens-of-micro"

  validation {
    condition     = contains(["tens-of-micro", "pico"], var.delay_unit)
    error_message = "Allowed values are `tens-of-micro` or `pico`."
  }
}

variable "bfd" {
  description = "BFD."
  type        = bool
  default     = false
}

variable "self_nexthop" {
  description = "Self Nexthop."
  type        = bool
  default     = true
}

variable "passive_interface" {
  description = "Passive interface."
  type        = bool
  default     = false
}

variable "split_horizon" {
  description = "Split Horizon."
  type        = bool
  default     = true
}


