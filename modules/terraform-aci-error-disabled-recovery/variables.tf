variable "interval" {
  description = "Interval. Minimum value: 30. Maximum value: 65535."
  type        = number
  default     = 300

  validation {
    condition     = var.interval >= 30 && var.interval <= 65535
    error_message = "Minimum value: 30. Maximum value: 65535."
  }
}

variable "mcp_loop" {
  description = "MCP loop recovery."
  type        = bool
  default     = false
}

variable "ep_move" {
  description = "EP move recovery."
  type        = bool
  default     = false
}

variable "bpdu_guard" {
  description = "BPDU guard recovery."
  type        = bool
  default     = false
}
