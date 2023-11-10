variable "tenant" {
  description = "Tenant name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.tenant))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "name" {
  description = "BGP Address Family Context Policy name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.name))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "description" {
  description = "BGP Address Family Context Policy description."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", var.description))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, }`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }
}

variable "enable_host_route_leak" {
  description = "Flag to enable host route leaking."
  type        = bool
  default     = false

}

variable "ebgp_distance" {
  description = "eBGP Distance. Allowed values `ebgp_distance`: 1-255."
  type        = number
  default     = 20

  validation {
    condition     = var.ebgp_distance >= 1 && var.ebgp_distance <= 255
    error_message = "Allowed values `ebgp_distance`: 1-255."
  }
}

variable "ibgp_distance" {
  description = "iBGP Distance. Allowed values `ibgp_distance`: 1-255."
  type        = number
  default     = 200

  validation {
    condition     = var.ibgp_distance >= 1 && var.ibgp_distance <= 255
    error_message = "Allowed values `ibgp_distance`: 1-255."
  }
}

variable "local_distance" {
  description = "Local Distance. Allowed values `local_distance`: 1-255."
  type        = number
  default     = 220

  validation {
    condition     = var.local_distance >= 1 && var.local_distance <= 255
    error_message = "Allowed values `local_distance`: 1-255."
  }
}

variable "local_max_ecmp" {
  description = "Local Maximum ECMP. Allowed values `local_max_ecmp`: 1-255."
  type        = number
  default     = 0

  validation {
    condition     = var.local_max_ecmp >= 0 && var.local_max_ecmp <= 16
    error_message = "Allowed values `local_max_ecmp`: 1-16."
  }
}

variable "ebgp_max_ecmp" {
  description = "eBGP Maximum ECMP. Allowed values `ebgp_max_ecmp`: 1-255."
  type        = number
  default     = 16

  validation {
    condition     = var.ebgp_max_ecmp >= 1 && var.ebgp_max_ecmp <= 64
    error_message = "Allowed values `ebgp_max_ecmp`: 1-16."
  }
}

variable "ibgp_max_ecmp" {
  description = "iBGP Maximum ECMP. Allowed values `ibgp_max_ecmp`: 1-255."
  type        = number
  default     = 16

  validation {
    condition     = var.ibgp_max_ecmp >= 1 && var.ibgp_max_ecmp <= 64
    error_message = "Allowed values `ibgp_max_ecmp`: 1-16."
  }
}
