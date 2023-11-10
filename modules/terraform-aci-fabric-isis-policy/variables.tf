variable "redistribute_metric" {
  description = "Redistribute metric. Minimum value: 1. Maximum value: 63."
  type        = number
  default     = 63

  validation {
    condition     = var.redistribute_metric >= 1 && var.redistribute_metric <= 63
    error_message = "Minimum value: 1. Maximum value: 63."
  }
}
