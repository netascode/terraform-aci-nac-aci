variable "name" {
  description = "PTP Profile name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,16}$", var.name))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "announce_interval" {
  description = "Announcement Interval. Minimum value: -3. Maximum value: 4."
  type        = number
  default     = 1

  validation {
    condition     = var.announce_interval >= -3 && var.announce_interval <= 4
    error_message = "Minimum value: -3. Maximum value: 4."
  }
}

variable "announce_timeout" {
  description = "Announcement Timeout. Minimum value: 2. Maximum value: 10."
  type        = number
  default     = 3

  validation {
    condition     = var.announce_timeout >= 2 && var.announce_timeout <= 10
    error_message = "Minimum value: 2. Maximum value: 10."
  }
}

variable "delay_interval" {
  description = "Delay Interval. Minimum value: -4. Maximum value: 5"
  type        = number
  default     = -3

  validation {
    condition     = var.delay_interval >= -4 && var.delay_interval <= 5
    error_message = "Minimum value: -4. Maximum value: 5."
  }
}

variable "forwardable" {
  description = "Destination MAC of PTP Messages"
  default     = true
  type        = bool
}

variable "priority" {
  description = "Teracom G.8275.1 Profile Priority. Minimum value: 1. Maximum value: 255."
  type        = number
  default     = 128

  validation {
    condition     = var.priority >= 1 && var.priority <= 255
    error_message = "Minimum value: 1. Maximum value: 255."
  }
}

variable "sync_interval" {
  description = "Sync Interval. Minimum value: -4. Maximum value: 1."
  type        = number
  default     = 1

  validation {
    condition     = var.sync_interval >= -4 && var.sync_interval <= 1
    error_message = "Minimum value: -4. Maximum value: 1."
  }
}

variable "template" {
  description = "Profile Template."
  type        = string
  default     = "aes67"

  validation {
    condition     = can(contains(["aes67", "smpte", "telecom"], var.template))
    error_message = "Allowed values: `aes67`, `smpte` or `telecom`."
  }
}

variable "mismatch_handling" {
  description = "Mismatched Destination MAC Handling."
  type        = string
  default     = "configured"

  validation {
    condition     = can(contains(["drop", "configured", "received"], var.mismatch_handling))
    error_message = "Allowed values: `drop`, `configured` or `received`."
  }
}