variable "name" {
  description = "Leaf switch policy group name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.name))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "forwarding_scale_policy" {
  description = "Forwarding scale policy name."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.forwarding_scale_policy))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}
