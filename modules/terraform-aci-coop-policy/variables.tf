variable "coop_group_policy" {
  description = "COOP group policy. Choices: `compatible`, `strict`."
  type        = string
  default     = "compatible"

  validation {
    condition     = contains(["compatible", "strict"], var.coop_group_policy)
    error_message = "Valid values are `compatible` or `strict`."
  }
}
