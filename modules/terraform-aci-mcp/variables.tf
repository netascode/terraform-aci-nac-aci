variable "admin_state" {
  description = "Admin state."
  type        = bool
  default     = false
}

variable "per_vlan" {
  description = "Per VLAN."
  type        = bool
  default     = false
}

variable "initial_delay" {
  description = "Initial delay."
  type        = number
  default     = 180

  validation {
    condition     = var.initial_delay >= 1 && var.initial_delay <= 1800
    error_message = "Minimum value: 1. Maximum value: 1800."
  }
}

variable "key" {
  description = "Key."
  type        = string
  default     = ""
  sensitive   = true
}

variable "loop_detection" {
  description = "Loop detection."
  type        = number
  default     = 3

  validation {
    condition     = var.loop_detection >= 1 && var.loop_detection <= 255
    error_message = "Minimum value: 1. Maximum value: 255."
  }
}

variable "disable_port_action" {
  description = "Disable port action."
  type        = bool
  default     = true
}

variable "frequency_sec" {
  description = "Frequency in seconds."
  type        = number
  default     = 2

  validation {
    condition     = var.frequency_sec >= 0 && var.frequency_sec <= 300
    error_message = "Minimum value: 0. Maximum value: 300."
  }
}

variable "frequency_msec" {
  description = "Frequency in milliseconds."
  type        = number
  default     = 0

  validation {
    condition     = var.frequency_msec >= 0 && var.frequency_msec <= 999
    error_message = "Minimum value: 0. Maximum value: 999."
  }
}
