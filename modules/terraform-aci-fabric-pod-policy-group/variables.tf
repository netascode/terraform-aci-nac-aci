variable "name" {
  description = "Pod policy group name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.name))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "snmp_policy" {
  description = "SNMP policy name."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.snmp_policy))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "date_time_policy" {
  description = "Date time policy name."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.date_time_policy))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "management_access_policy" {
  description = "Management access policy name."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.management_access_policy))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}
