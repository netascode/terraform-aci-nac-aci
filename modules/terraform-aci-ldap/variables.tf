variable "ldap_providers" {
  description = "LDAP Provider"
  type = list(object({
    hostname_ip          = string
    description          = optional(string, "")
    port                 = optional(number, 389)
    bind_dn              = optional(string, "")
    base_dn              = optional(string, "")
    password             = optional(string, "")
    timeout              = optional(number, 30)
    retries              = optional(number, 1)
    enable_ssl           = optional(bool, false)
    filter               = optional(string, "")
    attribute            = optional(string, "")
    ssl_validation_level = optional(string, "strict")
    mgmt_epg_type        = optional(string, "inb")
    mgmt_epg_name        = optional(string, "")
    monitoring           = optional(bool, false)
    monitoring_username  = optional(string, "default")
    monitoring_password  = optional(string, "")
  }))
  default = []

  validation {
    condition = alltrue([
      for p in var.ldap_providers : can(regex("^[a-zA-Z0-9_.:-]{0,64}$", p.hostname_ip))
    ])
    error_message = "`name`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for p in var.ldap_providers : can(regex("^[a-zA-Z0-9\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", p.description))
    ])
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, }`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }

  validation {
    condition = alltrue([
      for p in var.ldap_providers : (p.port >= 0 && p.port <= 65535)
    ])
    error_message = "Minimum value: 0, Maximum value: 65535."
  }

  validation {
    condition = alltrue([
      for p in var.ldap_providers : (p.timeout >= 0 && p.timeout <= 60)
    ])
    error_message = "Minimum value: 0, Maximum value: 60."
  }

  validation {
    condition = alltrue([
      for p in var.ldap_providers : (p.retries >= 0 && p.retries <= 5)
    ])
    error_message = "Minimum value: 0, Maximum value: 5."
  }

  validation {
    condition = alltrue([
      for p in var.ldap_providers : contains(["permissive", "strict"], p.ssl_validation_level)
    ])
    error_message = "Allowed values are `permissive` or `strict`."
  }

  validation {
    condition = alltrue([
      for p in var.ldap_providers : contains(["inb", "oob"], p.mgmt_epg_type)
    ])
    error_message = "Allowed values are `inb` or `oob`."
  }

  validation {
    condition = alltrue([
      for p in var.ldap_providers : can(regex("^[a-zA-Z0-9_.-]{0,64}$", p.mgmt_epg_name))
    ])
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for p in var.ldap_providers : p.monitoring_username == "" || can(regex("^[a-zA-Z0-9][a-zA-Z0-9_.@-]{0,31}$", p.monitoring_username))
    ])
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `@`, `-`. Maximum characters: 31."
  }
}

variable "group_map_rules" {
  description = "LDAP Group Map Rules"
  type = list(object({
    name        = string
    description = optional(string, "")
    group_dn    = optional(string, "")
    security_domains = optional(list(object({
      name = string
      roles = optional(list(object({
        name           = string
        privilege_type = optional(string, "read")
      })), [])
    })), [])
  }))
  default = []

  validation {
    condition = alltrue([
      for r in var.group_map_rules : can(regex("^[a-zA-Z0-9_.:-]{0,64}$", r.name))
    ])
    error_message = "`name`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for r in var.group_map_rules : can(regex("^[a-zA-Z0-9\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", r.description))
    ])
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, }`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }

  validation {
    condition = alltrue([
      for r in var.group_map_rules : can([for d in coalesce(r.security_domains, []) : regex("^[a-zA-Z0-9_.:-]{0,64}$", d.name)])
    ])
    error_message = "`security_domains.name`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for r in var.group_map_rules : can([for d in coalesce(r.security_domains, []) : [for role in coalesce(d.roles, []) : regex("^[a-zA-Z0-9_.:-]{0,64}$", role.name)]])
    ])
    error_message = "`security_domains.roles.name`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue(flatten([
      for r in var.group_map_rules : [for d in coalesce(r.security_domains, []) : [for role in coalesce(d.roles, []) : role.privilege_type == null || try(contains(["write", "read"], role.privilege_type), false)]]
    ]))
    error_message = "`privilege_type`: Allowed values are `write` or `read`."
  }
}

variable "group_maps" {
  description = "LDAP Group Maps"
  type = list(object({
    name  = string
    rules = list(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for m in var.group_maps : can(regex("^[a-zA-Z0-9_.:-]{0,64}$", m.name))
    ])
    error_message = "`name`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

