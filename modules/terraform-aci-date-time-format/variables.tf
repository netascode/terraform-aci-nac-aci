variable "display_format" {
  description = "Display format. Choices: `local`, `utc`."
  type        = string
  default     = "local"

  validation {
    condition     = contains(["local", "utc"], var.display_format)
    error_message = "Valid values are `local` or `utc`."
  }
}

variable "timezone" {
  description = "Timezone. Format: `p0_UTC`. See: https://pubhub.devnetcloud.com/media/apic-mim-ref-501/docs/MO-datetimeFormat.html#tz."
  type        = string
  default     = "p0_UTC"
}

variable "show_offset" {
  description = "Show offset."
  type        = bool
  default     = true
}
