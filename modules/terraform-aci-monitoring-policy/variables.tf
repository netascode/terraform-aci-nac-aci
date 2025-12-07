variable "snmp_trap_policies" {
  description = "List of SNMP trap source policies."
  type = list(object({
    name       = string
    dest_group = string
  }))
  default = []

  validation {
    condition = alltrue([
      for snmp in var.snmp_trap_policies : can(regex("^[a-zA-Z0-9_.:-]{0,64}$", snmp.name))
    ])
    error_message = "Allowed characters `name`: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for snmp in var.snmp_trap_policies : can(regex("^[a-zA-Z0-9_.:-]{0,64}$", snmp.dest_group))
    ])
    error_message = "Allowed characters `dest_group`: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "syslog_policies" {
  description = "List of syslog source policies. Default value `audit`: true. Default value `events`: true. Default value `faults`: true. Default value `session`: false. Default value `minimum_severity`: `warnings`."
  type = list(object({
    name             = string
    dest_group       = string
    audit            = optional(bool, true)
    events           = optional(bool, true)
    faults           = optional(bool, true)
    session          = optional(bool, false)
    minimum_severity = optional(string, "warnings")
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
      for syslog in var.syslog_policies : can(regex("^[a-zA-Z0-9_.:-]{0,64}$", syslog.dest_group))
    ])
    error_message = "Allowed characters `dest_group`: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for syslog in var.syslog_policies : contains(["emergencies", "alerts", "critical", "errors", "warnings", "notifications", "information", "debugging"], syslog.minimum_severity)
    ])
    error_message = "`minimum_severity`: Allowed values are `emergencies`, `alerts`, `critical`, `errors`, `warnings`, `notifications`, `information` or `debugging`."
  }
}

