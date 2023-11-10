variable "interface_preference" {
  description = "Interface preference. Choices: `inband`, `ooband`"
  type        = string
  default     = "inband"

  validation {
    condition     = contains(["inband", "ooband"], var.interface_preference)
    error_message = "Valid values are `inband` or `ooband`."
  }
}
