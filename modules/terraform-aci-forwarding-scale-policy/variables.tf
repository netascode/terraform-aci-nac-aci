variable "name" {
  description = "Forwarding scale policy name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.name))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "profile" {
  description = "Profile. Choices: `dual-stack`, `ipv4`, `high-dual-stack`, `high-lpm`."
  type        = string
  default     = "dual-stack"

  validation {
    condition     = contains(["dual-stack", "ipv4", "high-dual-stack", "high-lpm"], var.profile)
    error_message = "Valid values are `dual-stack`, `ipv4`, `high-dual-stack` or `high-lpm`."
  }
}
