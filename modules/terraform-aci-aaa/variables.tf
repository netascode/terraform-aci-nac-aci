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
  description = "Default realm. Choices: `local`, `tacacs`, `radius`, `ldap`."
  type        = string
  default     = "local"

  validation {
    condition     = contains(["local", "tacacs", "radius", "ldap"], var.default_realm)
    error_message = "Valid values are `local`, `tacacs` or `radius`."
  }
}

variable "default_login_domain" {
  description = "Default login domain."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.default_login_domain))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "console_realm" {
  description = "Console realm. Choices: `local`, `tacacs`, `radius`, `ldap`."
  type        = string
  default     = "local"

  validation {
    condition     = contains(["local", "tacacs", "radius", "ldap"], var.console_realm)
    error_message = "Valid values are `local`, `tacacs` or `radius`."
  }
}

variable "console_login_domain" {
  description = "Console login domain."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.console_login_domain))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
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
      for sd in var.security_domains : sd.description == null || can(regex("^[a-zA-Z0-9\\\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", sd.description))
    ])
    error_message = "`description`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, }`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }

  validation {
    condition = alltrue([
      for sd in var.security_domains : can(regex("^[a-zA-Z0-9_.:-]{0,64}$", sd.name))
    ])
    error_message = "`name`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "password_strength_check" {
  description = "Password strength check."
  type        = bool
  default     = false
}

variable "min_password_length" {
  description = "Minimum password length."
  type        = number
  default     = 8

  validation {
    condition     = var.min_password_length >= 8 && var.min_password_length <= 64
    error_message = "Allowed values `min_password_length`: 8-64."
  }
}

variable "max_password_length" {
  description = "Maximum password length."
  type        = number
  default     = 64

  validation {
    condition     = var.max_password_length >= 8 && var.max_password_length <= 64
    error_message = "Allowed values `max_password_length`: 8-64."
  }
}

variable "password_strength_test_type" {
  description = "Password strength test type for Password Strength Policy"
  type        = string
  default     = "default"

  validation {
    condition     = contains(["default", "custom"], var.password_strength_test_type)
    error_message = "Allowed values `password_strength_test_type`: default, custom"
  }
}

variable "password_class_flags" {
  description = "Password class flags for Password Strength Policy"
  type        = list(string)
  default     = ["digits", "lowercase", "uppercase"]

  validation {
    condition = length(var.password_class_flags) >= 3 && alltrue([
      for d in var.password_class_flags : contains(["digits", "lowercase", "specialchars", "uppercase"], d)
    ])
    error_message = "Allowed values `password_class_flags`: a combination of at least three out of four options: digits,lowercase,specialchars,uppercase."
  }
}

variable "password_change_during_interval" {
  description = "Enables or disables password change during interval."
  type        = bool
  default     = true
}

variable "password_change_count" {
  description = "The number of password changes allowed within the change interval."
  type        = number
  default     = 2

  validation {
    condition     = var.password_change_count >= 0 && var.password_change_count <= 10
    error_message = "Allowed values `password_change_interval`: 0-10."
  }
}

variable "password_change_interval" {
  description = "A time interval (hours) for limiting the number of password changes."
  type        = number
  default     = 48

  validation {
    condition     = var.password_change_interval >= 0 && var.password_change_interval <= 745
    error_message = "Allowed values `password_change_interval`: 0-745."
  }
}

variable "password_no_change_interval" {
  description = "A minimum period after a password change before the user can change the password again."
  type        = number
  default     = 24

  validation {
    condition     = var.password_no_change_interval >= 0 && var.password_no_change_interval <= 745
    error_message = "Allowed values `password_no_change_interval`: 0-745."
  }
}

variable "password_history_count" {
  description = "Number of recent user passwords to store."
  type        = number
  default     = 5

  validation {
    condition     = var.password_history_count >= 0 && var.password_history_count <= 15
    error_message = "Allowed values `password_history_count`: 0-15."
  }
}

variable "web_token_timeout" {
  description = "Web session idle timeout (s)."
  type        = number
  default     = 600

  validation {
    condition     = var.web_token_timeout >= 300 && var.web_token_timeout <= 9600
    error_message = "Allowed values `web_token_timeout`: 300-9600 sec."
  }
}

variable "web_token_max_validity" {
  description = "Web token maximum validity period (h)."
  type        = number
  default     = 24

  validation {
    condition     = var.web_token_max_validity >= 4 && var.web_token_max_validity <= 24
    error_message = "Allowed values `web_token_max_validity`: 4-24."
  }
}

variable "web_session_idle_timeout" {
  description = "Web session idle timeout (s)."
  type        = number
  default     = 1200

  validation {
    condition     = var.web_session_idle_timeout >= 60 && var.web_session_idle_timeout <= 65525
    error_message = "Allowed values `web_session_idle_timeout`: 60-65525."
  }
}

variable "include_refresh_session_records" {
  description = "Enables or disables inluding a refresh in the session records."
  type        = bool
  default     = true
}

variable "enable_login_block" {
  description = "Enables or disables lockout user after multiple failed login attempts."
  type        = bool
  default     = false
}

variable "login_block_duration" {
  description = "Duration in minutes for which future logins should be blocked."
  type        = number
  default     = 60

  validation {
    condition     = var.login_block_duration >= 1 && var.login_block_duration <= 1440
    error_message = "Allowed values `login_block_duration`: 1-1440."
  }
}

variable "login_max_failed_attempts" {
  description = "Max failed login attempts before blocking user login."
  type        = number
  default     = 5

  validation {
    condition     = var.login_max_failed_attempts >= 1 && var.login_max_failed_attempts <= 15
    error_message = "Allowed values `login_max_failed_attempts`: 1-15."
  }
}

variable "login_max_failed_attempts_window" {
  description = "Time period (unit: minute) in which consecutive attempts were failed."
  type        = number
  default     = 5

  validation {
    condition     = var.login_max_failed_attempts_window >= 1 && var.login_max_failed_attempts_window <= 720
    error_message = "Allowed values `login_max_failed_attempts_window`: 1-720."
  }
}
