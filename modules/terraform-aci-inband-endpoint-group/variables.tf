variable "name" {
  description = "Inband endpoint group name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.name))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "vlan" {
  description = "Vlan ID. Minimum value: 1. Maximum value: 4096."
  type        = number

  validation {
    condition     = var.vlan >= 1 && var.vlan <= 4096
    error_message = "Minimum value: 1. Maximum value: 4096."
  }
}

variable "bridge_domain" {
  description = "Bridge domain name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.bridge_domain))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "contract_consumers" {
  description = "List of contract consumers."
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for c in var.contract_consumers : can(regex("^[a-zA-Z0-9_.:-]{0,64}$", c))
    ])
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "contract_providers" {
  description = "List of contract providers."
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for c in var.contract_providers : can(regex("^[a-zA-Z0-9_.:-]{0,64}$", c))
    ])
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "contract_imported_consumers" {
  description = "List of imported contract consumers."
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for c in var.contract_imported_consumers : can(regex("^[a-zA-Z0-9_.:-]{0,64}$", c))
    ])
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "static_routes" {
  description = "List of inband Static routes"
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for c in var.static_routes : can(cidrsubnet(c, 0, 0))
    ])
    error_message = "Must be a valid IP address in CIDR notation."
  }
}