variable "name" {
  description = "Login domain name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.name))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
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

variable "realm" {
  description = "Realm. Choices: `local`, `tacacs`, `ldap`."
  type        = string

  validation {
    condition     = contains(["local", "tacacs", "ldap"], var.realm)
    error_message = "Allowed values: `local`, `tacacs` or `ldap`."
  }
}

variable "auth_choice" {
  description = "Authentication choice. Choices: `CiscoAVPair`, `LdapGroupMap`."
  type        = string
  default     = "CiscoAVPair"

  validation {
    condition     = contains(["CiscoAVPair", "LdapGroupMap"], var.auth_choice)
    error_message = "Allowed values: `CiscoAVPair` or `LdapGroupMap`."
  }
}

variable "ldap_group_map" {
  description = "LDAP group map."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,31}$", var.ldap_group_map))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 31."
  }
}

variable "tacacs_providers" {
  description = "List of TACACS providers. Allowed values `priority`: 0-16. Default value `priority`: 0"
  type = list(object({
    hostname_ip = string
    priority    = optional(number, 0)
  }))
  default = []

  validation {
    condition = alltrue([
      for p in var.tacacs_providers : (p.priority >= 0 && p.priority <= 16)
    ])
    error_message = "`priority`: Minimum value: 0. Maximum value: 16."
  }
}

variable "ldap_providers" {
  description = "List of LDAP providers. Allowed values `priority`: 0-16. Default value `priority`: 0"
  type = list(object({
    hostname_ip = string
    priority    = optional(number, 0)
  }))
  default = []

  validation {
    condition = alltrue([
      for p in var.ldap_providers : (p.priority >= 0 && p.priority <= 16)
    ])
    error_message = "`priority`: Minimum value: 0. Maximum value: 16."
  }
}
