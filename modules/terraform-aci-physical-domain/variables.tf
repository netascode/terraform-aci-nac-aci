variable "name" {
  description = "Physical domain name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.name))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "vlan_pool" {
  description = "Vlan pool name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.vlan_pool))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "vlan_pool_allocation" {
  description = "Vlan pool allocation mode. Choices: `static`, `dynamic`."
  type        = string
  default     = "static"

  validation {
    condition     = contains(["static", "dynamic"], var.vlan_pool_allocation)
    error_message = "Allowed values are `static` or `dynamic`."
  }
}

variable "security_domains" {
  description = "Security domains associated to physical domain"
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for s in var.security_domains : can(regex("^[a-zA-Z0-9_.:-]{0,64}$", s))
    ])
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}