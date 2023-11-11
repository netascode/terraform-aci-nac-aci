variable "admin_state" {
  description = "System Performance administrative state."
  type        = bool
  default     = false
}

variable "response_threshold" {
  description = "Threshold value for response time of any requests to Nginx."
  type        = number
  default     = 85000

  validation {
    condition     = var.response_threshold >= 40 && var.response_threshold <= 85000
    error_message = "Valid values are 40 to 85000."
  }
}

variable "top_slowest_requests" {
  description = "Property to set the number of slowest requests to be seen."
  type        = number
  default     = 5

  validation {
    condition     = var.top_slowest_requests >= 1 && var.top_slowest_requests <= 10
    error_message = "Valid values are 1 to 10."
  }
}

variable "calculation_window" {
  description = "Window in which average time, and number of requests that go beyond the threshold is calculated."
  type        = number
  default     = 300

  validation {
    condition     = var.calculation_window >= 30 && var.calculation_window <= 900
    error_message = "Frequency in which nginx is checked for avg response time in multiple of 30 sec with a maximum value of 900sec."
  }
}
