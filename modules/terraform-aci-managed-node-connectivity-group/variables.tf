variable "name" {
  description = "Managed node connectivity group name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.name))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "oob_mgmt_epg" {
  description = "Out-of-band management EPG name, under the `mgmt` tenant. An empty string disables the out-of-band zone's EPG association."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.oob_mgmt_epg))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "oob_ip_address_pool" {
  description = "Out-of-band IP address pool name, under the `mgmt` tenant. An empty string disables the out-of-band zone's address pool association."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.oob_ip_address_pool))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "inb_mgmt_epg" {
  description = "In-band management EPG name, under the `mgmt` tenant. An empty string disables the in-band zone's EPG association."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.inb_mgmt_epg))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "inb_ip_address_pool" {
  description = "In-band IP address pool name, under the `mgmt` tenant. An empty string disables the in-band zone's address pool association."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.inb_ip_address_pool))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}
