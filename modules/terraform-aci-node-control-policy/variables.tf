variable "name" {
  description = "Node control policy name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.name))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "dom" {
  description = "Digital optical monitoring (DOM)."
  type        = bool
  default     = false
}

variable "telemetry" {
  description = "Telemetry. Choices: `netflow`, `telemetry`, `analytics`."
  type        = string
  default     = "telemetry"

  validation {
    condition     = contains(["netflow", "telemetry", "analytics"], var.telemetry)
    error_message = "Allowed values: `netflow`, `telemetry` or `analytics`."
  }
}
