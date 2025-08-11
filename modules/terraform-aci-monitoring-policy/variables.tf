variable "snmp_trap_policies" {
  description = "List of SNMP trap policies."
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
    audit             = optional(bool, true)
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

  validation {
    condition = alltrue([
      for syslog in var.syslog_policies : can(regex("^[a-zA-Z0-9_.:-]{0,64}$", syslog.destination_group))
    ])
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}
