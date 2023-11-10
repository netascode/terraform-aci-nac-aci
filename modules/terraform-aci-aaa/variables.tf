variable "remote_user_login_policy" {
  description = "Remote user login policy. Choices: `assign-default-role`, `no-login`"
  type        = string
  default     = "no-login"

  validation {
    condition     = contains(["assign-default-role", "no-login"], var.remote_user_login_policy)
    error_message = "Valid values are `assign-default-role` or `no-login`."
  }
}

variable "default_fallback_check" {
  description = "Default fallback check."
  type        = bool
  default     = false
}

variable "default_realm" {
  description = "Default realm. Choices: `local`, `tacacs`."
  type        = string
  default     = "local"

  validation {
    condition     = contains(["local", "tacacs"], var.default_realm)
    error_message = "Valid values are `local` or `tacacs`."
  }
}

variable "default_login_domain" {
  description = "Default login domain."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.default_login_domain))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "console_realm" {
  description = "Console realm. Choices: `local`, `tacacs`."
  type        = string
  default     = "local"

  validation {
    condition     = contains(["local", "tacacs"], var.console_realm)
    error_message = "Valid values are `local` or `tacacs`."
  }
}

variable "console_login_domain" {
  description = "Console login domain."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.console_login_domain))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "security_domains" {
  description = "List of security domains."
  type = list(object({
    name                   = string
    description            = optional(string, "")
    restricted_rbac_domain = optional(bool, false)
  }))
  default = []

  validation {
    condition = alltrue([
      for sd in var.security_domains : sd.description == null || can(regex("^[a-zA-Z0-9\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", sd.description))
    ])
    error_message = "`description`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, }`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }

  validation {
    condition = alltrue([
      for sd in var.security_domains : can(regex("^[a-zA-Z0-9_.-]{0,64}$", sd.name))
    ])
    error_message = "`name`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}