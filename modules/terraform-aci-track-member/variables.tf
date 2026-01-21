variable "tenant" {
  description = "Tenant name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.tenant))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "name" {
  description = "Track Member name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.name))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "description" {
  description = "Description."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9\\\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", var.description))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, }`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }
}

variable "destination_ip" {
  description = "Destination IP to be tracked"
  type        = string
}

variable "scope_type" {
  description = "Type of scope of track member. Allowed value: `l3out`, `bd`."
  type        = string

  validation {
    condition     = contains(["l3out", "bd"], var.scope_type)
    error_message = "Allowed values: `l3out`, `bd`."
  }
}

variable "scope" {
  description = "Scope of track member."
  type        = string
}

variable "ip_sla_policy" {
  description = "IP SLA Policy of a track member"
  type        = string
}

variable "ip_sla_policy_tenant" {
  description = "Tenant name used in reference for ip_sla_policy resolved automatically."
  type        = string
  default     = ""
}
