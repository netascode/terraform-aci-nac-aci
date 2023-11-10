variable "hostname_ip" {
  description = "Hostname or IP."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9:][a-zA-Z0-9.:-]{0,254}$", var.hostname_ip))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `.`, `:`, `-`. Maximum characters: 254."
  }
}

variable "description" {
  description = "Description."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", var.description))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, }`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }
}

variable "protocol" {
  description = "Protocol. Choices: `pap`, `chap`, `mschap`."
  type        = string
  default     = "pap"

  validation {
    condition     = contains(["pap", "chap", "mschap"], var.protocol)
    error_message = "Allowed values are `pap`, `chap` or `mschap`."
  }
}

variable "monitoring" {
  description = "Monitoring."
  type        = bool
  default     = false
}

variable "monitoring_username" {
  description = "Monitoring username."
  type        = string
  default     = ""

  validation {
    condition     = var.monitoring_username == "" || can(regex("^[a-zA-Z0-9][a-zA-Z0-9_.@-]{0,31}$", var.monitoring_username))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `@`, `-`. Maximum characters: 31."
  }
}

variable "monitoring_password" {
  description = "Monitoring password."
  type        = string
  default     = ""
  sensitive   = true
}

variable "key" {
  description = "Key."
  type        = string
  default     = ""
  sensitive   = true
}

variable "port" {
  description = "Port. Minimum value: 0, Maximum value: 65535."
  type        = number
  default     = 49

  validation {
    condition     = var.port >= 0 && var.port <= 65535
    error_message = "Minimum value: 0, Maximum value: 65535."
  }
}

variable "retries" {
  description = "Retries. Minimum value: 0, Maximum value: 5."
  type        = number
  default     = 1

  validation {
    condition     = var.retries >= 0 && var.retries <= 5
    error_message = "Minimum value: 0, Maximum value: 5."
  }
}

variable "timeout" {
  description = "Timeout. Minimum value: 0, Maximum value: 60."
  type        = number
  default     = 5

  validation {
    condition     = var.timeout >= 0 && var.timeout <= 60
    error_message = "Minimum value: 0, Maximum value: 60."
  }
}

variable "mgmt_epg_type" {
  description = "Management EPG type. Choices: `inb`, `oob`."
  type        = string
  default     = "inb"

  validation {
    condition     = contains(["inb", "oob"], var.mgmt_epg_type)
    error_message = "Allowed values are `inb` or `oob`."
  }
}

variable "mgmt_epg_name" {
  description = "Management EPG name."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.mgmt_epg_name))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}
