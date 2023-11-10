variable "name" {
  description = "OOB endpoint group name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.name))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "oob_contract_providers" {
  description = "List of OOB contract providers."
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for c in var.oob_contract_providers : can(regex("^[a-zA-Z0-9_.-]{0,64}$", c))
    ])
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "static_routes" {
  description = "List of OOB Static routes"
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for c in var.static_routes : can(cidrsubnet(c, 0, 0))
    ])
    error_message = "Must be a valid IP address in CIDR notation."
  }
}