variable "tenant" {
  description = "Tenant name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.tenant))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "name" {
  description = "Contract name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.name))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "alias" {
  description = "Contract alias."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.alias))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "description" {
  description = "Contract description."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", var.description))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, }`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }
}

variable "scope" {
  description = "Contract scope. Choices: `application-profile`, `tenant`, `context`, `global`."
  type        = string
  default     = "context"

  validation {
    condition     = contains(["application-profile", "tenant", "context", "global"], var.scope)
    error_message = "Valid values are `application-profile`, `tenant`, `context` or `global`."
  }
}

variable "qos_class" {
  description = "Contract QoS Class. Choices: `unspecified`, `level1`, `level2`, `level3`, `level4`, `level5`, `level6`."
  type        = string
  default     = "unspecified"

  validation {
    condition     = contains(["unspecified", "level1", "level2", "level3", "level4", "level5", "level6"], var.qos_class)
    error_message = "Valid values are `default`, `level1`, `level2`, `level3`, `level4`, `level5`, `level6`."
  }
}

variable "target_dscp" {
  description = "Contract Target DSCP. Valid values are `unspecified`, `CS0`, `CS1`, `AF11`, `AF12`, `AF13`, `CS2`, `AF21`, `AF22`, `AF23`, `CS4`, `AF41`, `AF42`, `AF43`, `CS5`, `VA`, `EF`, `CS6`, `CS7` or a number between 0 and 63."
  type        = string
  default     = "unspecified"

  validation {
    condition     = try(contains(["unspecified", "CS0", "CS1", "AF11", "AF12", "AF13", "CS2", "AF21", "AF22", "AF23", "CS4", "AF41", "AF42", "AF43", "CS5", "VA", "EF", "CS6", "CS7"], var.target_dscp), false) || try(tonumber(var.target_dscp) >= 0 && tonumber(var.target_dscp) <= 63, false)
    error_message = "Valid values are `unspecified`, `CS0`, `CS1`, `AF11`, `AF12`, `AF13`, `CS2`, `AF21`, `AF22`, `AF23`, `CS4`, `AF41`, `AF42`, `AF43`, `CS5`, `VA`, `EF`, `CS6`, `CS7` or a number between 0 and 63."
  }
}


variable "subjects" {
  description = "List of contract subjects. Choices `action`: `permit`, `deny`. Default value `action`: `permit`. Choices `priority`: `default`, `level1`, `level2`, `level3`. Default value `priority`: `default`. Default value `log`: `false`. Default value `no_stats`: `false`. Choices `qos_class`: `unspecified`, `level1`, `level2`, `level3`, `level4`, `level5` or`level6`. Default value `qos_class`: `unspecified`. Choices `dscp_target` : `unspecified`, `CS0`, `CS1`, `AF11`, `AF12`, `AF13`, `CS2`, `AF21`, `AF22`, `AF23`, `CS4`, `AF41`, `AF42`, `AF43`, `CS5`, `VA`, `EF`, `CS6` `CS7` or a number between 0 and 63. Default value `dscp_target`: `unspecified`"
  type = list(object({
    name          = string
    alias         = optional(string, "")
    description   = optional(string, "")
    service_graph = optional(string)
    qos_class     = optional(string, "unspecified")
    target_dscp   = optional(string, "unspecified")
    filters = optional(list(object({
      filter   = string
      action   = optional(string, "permit")
      priority = optional(string, "default")
      log      = optional(bool, false)
      no_stats = optional(bool, false)
    })), [])
  }))
  default = []

  validation {
    condition = alltrue([
      for s in var.subjects : can(regex("^[a-zA-Z0-9_.-]{0,64}$", s.name))
    ])
    error_message = "`name`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for s in var.subjects : s.alias == null || can(regex("^[a-zA-Z0-9_.-]{0,64}$", s.alias))
    ])
    error_message = "`alias`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for s in var.subjects : s.description == null || can(regex("^[a-zA-Z0-9\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", s.description))
    ])
    error_message = "`description`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, }`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }

  validation {
    condition = alltrue([
      for s in var.subjects : try(contains(["unspecified", "level1", "level2", "level3", "level4", "level5", "level6"], s.qos_class), false)
    ])
    error_message = "`qos_class`: Allowed values are `unspecified`, `level1`, `level2`, `level3`, `level4`, `level5` or`level6`"
  }

  validation {
    condition = alltrue([
      for s in var.subjects : try(contains(["unspecified", "CS0", "CS1", "AF11", "AF12", "AF13", "CS2", "AF21", "AF22", "AF23", "CS4", "AF41", "AF42", "AF43", "CS5", "VA", "EF", "CS6", "CS7"], s.target_dscp), false) || try(tonumber(s.target_dscp) >= 0 && tonumber(s.target_dscp) <= 63, false)
    ])
    error_message = "`target_dscp`: Allowed values are `unspecified`, `CS0`, `CS1`, `AF11`, `AF12`, `AF13`, `CS2`, `AF21`, `AF22`, `AF23`, `CS4`, `AF41`, `AF42`, `AF43`, `CS5`, `VA`, `EF`, `CS6`, `CS7` or a number between 0 and 63."
  }

  validation {
    condition = alltrue([
      for s in var.subjects : s.service_graph == null || can(regex("^[a-zA-Z0-9_.-]{0,64}$", s.service_graph))
    ])
    error_message = "`service_graph`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue(flatten([
      for s in var.subjects : [for f in coalesce(s.filters, []) : can(regex("^[a-zA-Z0-9_.-]{0,64}$", f.filter))]
    ]))
    error_message = "`filter`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue(flatten([
      for s in var.subjects : [for f in coalesce(s.filters, []) : f.action == null || try(contains(["permit", "deny"], f.action), false)]
    ]))
    error_message = "`action`: Allowed values are `permit` or `deny`."
  }

  validation {
    condition = alltrue(flatten([
      for s in var.subjects : [for f in coalesce(s.filters, []) : f.priority == null || try(contains(["default", "level1", "level2", "level3"], f.priority), false)]
    ]))
    error_message = "`priority`: Allowed values are `default`, `level1`, `level2` or `level3`."
  }
}
