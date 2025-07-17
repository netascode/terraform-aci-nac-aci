variable "name" {
  description = "Track List name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.name))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "description" {
  description = "Description."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9\\\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", var.description))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, }`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }
}

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

variable "fault_severity_policies" {
  description = "List of Fault Severity Assignment Policies."
  type = list(object({
    class = string
    faults = list(object({
      fault_id         = string
      initial_severity = optional(string, "inherit")
      target_severity  = optional(string, "inherit")
      description      = optional(string, "")
    }))
  }))
  default = []

  validation {
    condition = alltrue([
      for policy in var.fault_severity_policies : can(regex("^[a-zA-Z0-9_.:-]{0,64}$", policy.class))
    ])
    error_message = "`class`. Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
  validation {
    condition = alltrue(flatten([
      for policy in var.fault_severity_policies : [
        for fault in policy.faults : fault.description == null || try(can(regex("^[a-zA-Z0-9\\\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", fault.description)), false)
      ]
    ]))
    error_message = "`faults.description`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, `}`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }

  validation {
    condition = alltrue(flatten([
      for policy in var.fault_severity_policies : [
        for fault in policy.faults : contains(["warning", "minor", "major", "critical", "squelched", "inherit"], fault.initial_severity)
      ]
    ]))
    error_message = "`initial_severity`: Allowed values are `warning`, `minor`, `major`, `critical`, `squelched` or `inherit`."
  }

  validation {
    condition = alltrue(flatten([
      for policy in var.fault_severity_policies : [
        for fault in policy.faults : contains(["warning", "minor", "major", "critical", "inherit"], fault.target_severity)
      ]
    ]))
    error_message = "`target_severity`: Allowed values are `warning`, `minor`, `major`, `critical` or `inherit`."
  }

  validation {
    condition = alltrue(flatten([
      for policy in var.fault_severity_policies : [
        for fault in policy.faults : index(["warning", "minor", "major", "critical", "", "inherit"], fault.target_severity) >= index(["warning", "minor", "major", "critical", "squelched", "inherit"], fault.initial_severity)
      ]
    ]))
    error_message = "`target_severity` level must be equal or higher than `initial_severity` level."
  }

}