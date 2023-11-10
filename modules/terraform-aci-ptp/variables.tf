variable "admin_state" {
  description = "PTP administrative state."
  type        = bool
  default     = false
}

variable "global_domain" {
  description = "Global domain."
  type        = number
  default     = null

  validation {
    condition     = var.global_domain == null ? true : (var.global_domain >= 0 && var.global_domain <= 128)
    error_message = "Valid values are 0 to 128."
  }
}

variable "profile" {
  description = "PTP profile. Choices: `aes67`, `default`, `smpte`, `telecom_full_path`."
  type        = string
  default     = null

  validation {
    condition     = var.profile == null ? true : (contains(["aes67", "default", "smpte", "telecom_full_path"], var.profile))
    error_message = "Valid values are `aes67`, `default`, `smpte`, `telecom_full_path."
  }
}

variable "announce_interval" {
  description = "Announce interval."
  type        = number
  default     = null

  validation {
    condition     = var.announce_interval == null ? true : (var.announce_interval >= -3 && var.announce_interval <= 4)
    error_message = "Valid values: `aes67`: 0 to 4, `default`: 0 to 4, `smpte`: -3 to 1, `telecom_full_path`: -3."
  }
}

variable "announce_timeout" {
  description = "Announce timeout."
  type        = number
  default     = null

  validation {
    condition     = var.announce_timeout == null ? true : (var.announce_timeout >= 2 && var.announce_timeout <= 10)
    error_message = "Valid values are 2 to 10 for `aes67`, `default`, and `smpte` profiles, and 2 to 4 for `telecom_full_path` profile."
  }
}

variable "sync_interval" {
  description = "Sync interval."
  type        = number
  default     = null

  validation {
    condition     = var.sync_interval == null ? true : (var.sync_interval >= -7 && var.sync_interval <= 1)
    error_message = "Valid values: `aes67`: -4 to 1, `default`: -1 to 1, `smpte`: -7 to 1, `telecom_full_path`: -4."
  }
}

variable "delay_interval" {
  description = "Delay interval."
  type        = number
  default     = null

  validation {
    condition     = var.delay_interval == null ? true : (var.delay_interval >= -7 && var.delay_interval <= 5)
    error_message = "Valid values: aes67: -3 to 5, default: 0 to 5, smpte: -7 to 4, telecom_full_path: -4"
  }
}
