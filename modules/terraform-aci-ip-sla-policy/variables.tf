variable "tenant" {
  description = "IP SLA Policy Tenant's name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.tenant))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "name" {
  description = "IP SLA Policy name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.name))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "description" {
  description = "IP SLA Policy description."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9\\\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", var.description))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, }`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }
}

variable "multiplier" {
  description = "IP SLA Policy multiplier. Allowed values `multiplier`: 1-100."
  type        = number
  default     = 3

  validation {
    condition     = var.multiplier >= 1 && var.multiplier <= 100
    error_message = "Allowed values `multiplier`: 1-100."
  }
}

variable "frequency" {
  description = "IP SLA Policy frequency. Allowed values `frequency`: 1-300."
  type        = number
  default     = 60

  validation {
    condition     = var.frequency >= 1 && var.frequency <= 300
    error_message = "Allowed values `frequency`: 1-300."
  }
}

variable "port" {
  description = "IP SLA Policy port. Allowed values `port`: 1-65535."
  type        = number
  default     = 0

  validation {
    condition     = var.port >= 0 && var.port <= 65535
    error_message = "Allowed values `port`: 1-65535."
  }
}

variable "sla_type" {
  description = "IP SLA Policy type. Valid values are `icmp`, `tcp`, `l2ping` or `http`."
  type        = string
  default     = "icmp"

  validation {
    condition     = contains(["icmp", "tcp", "l2ping", "http"], var.sla_type)
    error_message = "Valid values are `icmp`, `tcp`, `l2ping` or `http`."
  }
}

variable "http_method" {
  description = "IP SLA Policy HTTP method. Only applicable when sla_type is 'http'."
  type        = string
  default     = null

  validation {
    condition     = var.http_method == null || contains(["get"], var.http_method)
    error_message = "Valid values are `get`."
  }
}

variable "http_version" {
  description = "IP SLA Policy HTTP version. Only applicable when sla_type is 'http'."
  type        = string
  default     = null

  validation {
    condition     = var.http_version == null || contains(["HTTP10", "HTTP11"], var.http_version)
    error_message = "Valid values are `HTTP10` or `HTTP11`."
  }
}

variable "http_uri" {
  description = "IP SLA Policy HTTP URI. Only applicable when sla_type is 'http'."
  type        = string
  default     = null

  validation {
    condition     = var.http_uri == null || can(regex("^/.{0,512}$", var.http_uri))
    error_message = "HTTP URI must start with '/' and be maximum 513 characters."
  }
}
