variable "name" {
  description = "Port channel member policy name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.name))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "priority" {
  description = "Priority. Minimum value: 1. Maximum value: 65535."
  type        = number
  default     = 32768

  validation {
    condition     = var.priority >= 1 && var.priority <= 65535
    error_message = "Minimum value: 1. Maximum value: 65535."
  }
}

variable "rate" {
  description = "Rate. Choices: `normal`, `fast`."
  type        = string
  default     = "normal"

  validation {
    condition     = contains(["normal", "fast"], var.rate)
    error_message = "Allowed values are `normal` or `fast`."
  }
}
