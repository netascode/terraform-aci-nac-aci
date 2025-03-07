variable "mac" {
  description = "MAC address. Format: `12:34:56:78:9A:BC`."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^([0-9A-Fa-f]{2}[:]){5}([0-9A-Fa-f]{2})$", var.mac))
    error_message = "Format: `12:34:56:78:9A:BC`."
  }
}

variable "bridge_domain" {
  description = "Bridge domain name."
  type        = string
  default     = "all"

  validation {
    condition     = var.bridge_domain == "all" || can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.bridge_domain))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "tenant" {
  description = "Tenant Name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.tenant))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "vrf" {
  description = "VRF Name."
  type        = string
  default     = null

  validation {
    condition     = var.vrf == null || can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.vrf))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "tags" {
  description = "Policy Tags"
  type = list(object({
    key   = string
    value = string
  }))
  default = []

  validation {
    condition = alltrue([
      for tag in coalesce(var.tags, []) : can(regex("^[a-zA-Z0-9_.:-]{0,64}$", tag.key))
    ])
    error_message = "`tags.key`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for tag in coalesce(var.tags, []) : can(regex("^[a-zA-Z0-9_.:-]{0,128}$", tag.value))
    ])
    error_message = "`tags.value`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 128."
  }
}
