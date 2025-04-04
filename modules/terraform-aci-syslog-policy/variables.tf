variable "name" {
  description = "Syslog policy name."
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

variable "format" {
  description = "Format. Choices: `aci`, `nxos`, `enhanced-log`."
  type        = string
  default     = "aci"

  validation {
    condition     = contains(["aci", "nxos", "enhanced-log"], var.format)
    error_message = "Allowed values are `aci`, `nxos` or `enhanced-log`."
  }
}

variable "show_millisecond" {
  description = "Show milliseconds."
  type        = bool
  default     = false
}

variable "show_timezone" {
  description = "Show timezone."
  type        = bool
  default     = false
}

variable "admin_state" {
  description = "Admin state."
  type        = bool
  default     = true
}

variable "local_admin_state" {
  description = "Local admin state."
  type        = bool
  default     = true
}

variable "local_severity" {
  description = "Local severity. Choices: `emergencies`, `alerts`, `critical`, `errors`, `warnings`, `notifications`, `information`, `debugging`."
  type        = string
  default     = "information"

  validation {
    condition     = contains(["emergencies", "alerts", "critical", "errors", "warnings", "notifications", "information", "debugging"], var.local_severity)
    error_message = "Allowed values are `emergencies`, `alerts`, `critical`, `errors`, `warnings`, `notifications`, `information` or `debugging`."
  }
}

variable "console_admin_state" {
  description = "Console admin state."
  type        = bool
  default     = true
}

variable "console_severity" {
  description = "Console severity. Choices: `emergencies`, `alerts`, `critical`, `errors`, `warnings`, `notifications`, `information`, `debugging`."
  type        = string
  default     = "alerts"

  validation {
    condition     = contains(["emergencies", "alerts", "critical", "errors", "warnings", "notifications", "information", "debugging"], var.console_severity)
    error_message = "Allowed values are `emergencies`, `alerts`, `critical`, `errors`, `warnings`, `notifications`, `information` or `debugging`."
  }
}

variable "destinations" {
  description = "List of destinations. Allowed values `protocol`: `udp`, `tcp`, `ssl`. Allowed values `port`: 0-65535. Default value `port`: 514. Choices `format`: `aci`, `nxos`. Default value `format`: `aci`. Choices `facility`: `local0`, `local1` ,`local2` ,`local3` ,`local4` ,`local5`, `local6`, `local7`. Default value `facility`: `local7`. Choices `severity`: `emergencies`, `alerts`, `critical`, `errors`, `warnings`, `notifications`, `information`, `debugging`. Default value `severity`: `warnings`. Choices `mgmt_epg_type`: `inb`, `oob`. Default value `mgmt_epg_type`: `inb`."
  type = list(object({
    name          = optional(string, "")
    hostname_ip   = string
    protocol      = optional(string)
    port          = optional(number, 514)
    admin_state   = optional(bool, true)
    format        = optional(string, "aci")
    facility      = optional(string, "local7")
    severity      = optional(string, "warnings")
    mgmt_epg_type = optional(string, "inb")
    mgmt_epg_name = optional(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for d in var.destinations : can(regex("^[a-zA-Z0-9_.:-]{0,64}$", d.name))
    ])
    error_message = "Allowed characters `name`: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for d in var.destinations : can(regex("^[a-zA-Z0-9:][a-zA-Z0-9.:-]{0,254}$", d.hostname_ip))
    ])
    error_message = "Allowed characters `hostname_ip`: `a`-`z`, `A`-`Z`, `0`-`9`, `.`, `:`, `-`. Maximum characters: 254."
  }

  validation {
    condition = alltrue([
      for d in var.destinations : d.protocol == null || try(contains(["udp", "tcp", "ssl"], d.protocol), false)
    ])
    error_message = "`protocol`: Allowed values are `udp`, `tcp` or `ssl`."
  }

  validation {
    condition = alltrue([
      for d in var.destinations : d.port == null || try(d.port >= 0 && d.port <= 65535, false)
    ])
    error_message = "`port`: Minimum value: 0. Maximum value: 65535."
  }

  validation {
    condition = alltrue([
      for d in var.destinations : d.format == null || try(contains(["aci", "nxos", "enhanced-log"], d.format), false)
    ])
    error_message = "`format`: Allowed values are `aci`, `nxos`, or `enhanced-log`."
  }

  validation {
    condition = alltrue([
      for d in var.destinations : d.facility == null || try(contains(["local0", "local1", "local2", "local3", "local4", "local5", "local6", "local7"], d.facility), false)
    ])
    error_message = "`facility`: Allowed values are `local0`, `local1` ,`local2` ,`local3` ,`local4` ,`local5`, `local6` or `local7`."
  }

  validation {
    condition = alltrue([
      for d in var.destinations : d.severity == null || try(contains(["emergencies", "alerts", "critical", "errors", "warnings", "notifications", "information", "debugging"], d.severity), false)
    ])
    error_message = "`severity`: Allowed values are `emergencies`, `alerts`, `critical`, `errors`, `warnings`, `notifications`, `information` or `debugging`."
  }

  validation {
    condition = alltrue([
      for d in var.destinations : d.mgmt_epg_type == null || try(contains(["inb", "oob"], d.mgmt_epg_type), false)
    ])
    error_message = "`mgmt_epg_type`: Allowed values are `inb` or `oob`."
  }

  validation {
    condition = alltrue([
      for d in var.destinations : can(regex("^[a-zA-Z0-9_.:-]{1,64}$", d.mgmt_epg_name))
    ])
    error_message = "Allowed characters `mgmt_epg_name`: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}
