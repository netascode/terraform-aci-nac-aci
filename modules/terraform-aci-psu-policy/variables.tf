variable "name" {
  description = "PSU policy name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.name))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "admin_state" {
  description = "Admin state. Choices: `combined`, `nnred`, `n1red`."
  type        = string
  default     = "combined"

  validation {
    condition     = contains(["combined", "nnred", "n1red"], var.admin_state)
    error_message = "Allowed values are `combined`, `nnred` or `n1red`."
  }
}
