variable "name" {
  description = "DNS policy name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.name))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "mgmt_epg_type" {
  description = "Management endpoint group type."
  type        = string
  default     = "inb"

  validation {
    condition     = contains(["inb", "oob"], var.mgmt_epg_type)
    error_message = "Allowed values are `inb` or `oob`."
  }
}

variable "mgmt_epg_name" {
  description = "Management endpoint group name."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.mgmt_epg_name))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "providers_" {
  description = "List of DNS providers. Default value `preferred`: false."
  type = list(object({
    ip        = string
    preferred = optional(bool, false)
  }))
  default = []
}

variable "domains" {
  description = "List of domains. Default value `default`: false."
  type = list(object({
    name    = string
    default = optional(bool, false)
  }))
  default = []

  validation {
    condition = alltrue([
      for d in var.domains : can(regex("^[a-zA-Z0-9_.:-]{0,64}$", d.name))
    ])
    error_message = "`name`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}
