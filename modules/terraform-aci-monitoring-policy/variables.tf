variable "snmp_trap_policies" {
  description = "List of SNMP trap policy names."
  type = list(object({
    name              = string
    destination_group = optional(string, "")
  }))
  default = []

  validation {
    condition = alltrue([
      for snmp in var.snmp_trap_policies : can(regex("^[a-zA-Z0-9_.:-]{0,64}$", snmp.name))
    ])
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for snmp in var.snmp_trap_policies : can(regex("^[a-zA-Z0-9_.:-]{0,64}$", snmp.destination_group))
    ])
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "syslog_policies" {
  description = "List of syslog policies. Default value `audit`: true. Default value `events`: true. Default value `faults`: true. Default value `session`: false. Default value `minimum_severity`: `warnings`."
  type = list(object({
    name              = string
    audit             = optional(bool, null)
    events            = optional(bool, true)
    faults            = optional(bool, true)
    session           = optional(bool, false)
    minimum_severity  = optional(string, "warnings")
    destination_group = optional(string, "")
  }))
  default = []

  validation {
    condition = alltrue([
      for syslog in var.syslog_policies : can(regex("^[a-zA-Z0-9_.:-]{0,64}$", syslog.name))
    ])
    error_message = "Allowed characters `name`: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for syslog in var.syslog_policies : contains(["emergencies", "alerts", "critical", "errors", "warnings", "notifications", "information", "debugging"], syslog.minimum_severity)
    ])
    error_message = "`minimum_severity`: Allowed values are `emergencies`, `alerts`, `critical`, `errors`, `warnings`, `notifications`, `information` or `debugging`."
  }
}

variable "tacacs_policies" {
  description = "List of TACACS monitoring policies. Default value `audit`: false."
  type = list(object({
    name              = string
    audit             = optional(bool, false)
    destination_group = optional(string, "")
  }))
  default = []

  validation {
    condition = alltrue([
      for tacacs in var.tacacs_policies : can(regex("^[a-zA-Z0-9_.:-]{0,64}$", tacacs.name))
    ])
    error_message = "Allowed characters `name`: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for tacacs in var.tacacs_policies : can(regex("^[a-zA-Z0-9_.:-]{0,64}$", tacacs.destination_group))
    ])
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}


variable "syslog_message_policy" {
  description = "System messages policy. `legacy_message_handling` requires APIC 6.1(2f)+ and is only configured when defined. Allowed values `legacy_message_handling`: `drop`, `monitor` or `eventrecord`."
  type = object({
    description             = optional(string, "")
    legacy_message_handling = optional(string)
    facility_filters = optional(list(object({
      facility         = string
      minimum_severity = string
    })), [])
  })
  default = null

  validation {
    condition     = can(regex("^[a-zA-Z0-9\\\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", try(var.syslog_message_policy.description, "")))
    error_message = "Allowed characters `description`: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, }`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }

  validation {
    condition     = try(var.syslog_message_policy.legacy_message_handling, null) == null || try(contains(["drop", "monitor", "eventrecord"], var.syslog_message_policy.legacy_message_handling), false)
    error_message = "`legacy_message_handling`: Allowed values are `drop`, `monitor` or `eventrecord`."
  }

  validation {
    condition = alltrue([
      for filter in try(var.syslog_message_policy.facility_filters, []) : contains(["auth", "authpriv", "cron", "daemon", "default", "ftp", "kern", "lpr", "mail", "news", "syslog", "user", "uucp", "local0", "local1", "local2", "local3", "local4", "local5", "local6", "local7"], filter.facility)
    ])
    error_message = "`facility`: Allowed values are `auth`, `authpriv`, `cron`, `daemon`, `default`, `ftp`, `kern`, `lpr`, `mail`, `news`, `syslog`, `user`, `uucp`, `local0`, `local1`, `local2`, `local3`, `local4`, `local5`, `local6` or `local7`."
  }

  validation {
    condition = alltrue([
      for filter in try(var.syslog_message_policy.facility_filters, []) : contains(["emergencies", "alerts", "critical", "errors", "warnings", "notifications", "information", "debugging"], filter.minimum_severity)
    ])
    error_message = "`minimum_severity`: Allowed values are `emergencies`, `alerts`, `critical`, `errors`, `warnings`, `notifications`, `information` or `debugging`."
  }
}
