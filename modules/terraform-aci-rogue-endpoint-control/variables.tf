variable "admin_state" {
  description = "Admin state."
  type        = bool
  default     = false
}

variable "hold_interval" {
  description = "Hold interval. Allowed values: 300-3600."
  type        = number
  default     = 1800

  validation {
    condition     = var.hold_interval >= 300 && var.hold_interval <= 3600
    error_message = "Minimum value: 300. Maximum value: 3600."
  }
}

variable "detection_interval" {
  description = "Detection interval. Allowed values: 30-3600."
  type        = number
  default     = 60

  validation {
    condition     = var.detection_interval >= 30 && var.detection_interval <= 3600
    error_message = "Minimum value: 30. Maximum value: 3600."
  }
}

variable "detection_multiplier" {
  description = "Detection multiplier. Allowed values: 2-65535."
  type        = number
  default     = 4

  validation {
    condition     = var.detection_multiplier >= 2 && var.detection_multiplier <= 65535
    error_message = "Minimum value: 2. Maximum value: 65535."
  }
}
