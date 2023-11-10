variable "tenant" {
  description = "Tenant name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.tenant))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "name" {
  description = "QoS Policy name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.name))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "alias" {
  description = "QoS Policy alias."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.alias))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "description" {
  description = "QoS Policy description."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", var.description))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, }`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }
}

variable "dscp_priority_maps" {
  description = "QoS Policy DSCP Priority Maps. Allowed values `dscp_from`, `dscp_to` and `dscp_target` : `unspecified`, `CS0`, `CS1`, `AF11`, `AF12`, `AF13`, `CS2`, `AF21`, `AF22`, `AF23`, `CS3`, `AF31`, `AF32`, `AF33`, `CS4`, `AF41`, `AF42`, `AF43`, `CS5`, `VA`, `EF`, `CS6` `CS7` or a number between 0 and 63. Allowed values `priority`: `unspecified`, `level1`, `level2`, `level3`, `level4`, `level5` or `level6`. Allowed values `cos_target`: `unspecified` or a number between 0 and 7."
  type = list(object({
    dscp_from   = string
    dscp_to     = optional(string)
    priority    = optional(string, "level3")
    dscp_target = optional(string, "unspecified")
    cos_target  = optional(string, "unspecified")
  }))
  default = []

  validation {
    condition = alltrue([
      for pm in var.dscp_priority_maps : try(contains(["unspecified", "CS0", "CS1", "AF11", "AF12", "AF13", "CS2", "AF21", "AF22", "AF23", "CS3", "AF31", "AF32", "AF33", "CS4", "AF41", "AF42", "AF43", "CS5", "VA", "EF", "CS6", "CS7"], pm.dscp_from), false) || try(tonumber(pm.dscp_from) >= 0 && tonumber(pm.dscp_from) <= 63, false)
    ])
    error_message = "`dscp_from`: Allowed values are `unspecified`, `CS0`, `CS1`, `AF11`, `AF12`, `AF13`, `CS2`, `AF21`, `AF22`, `AF23`, `CS3`, `AF31`, `AF32`, `AF33`, `CS4`, `AF41`, `AF42`, `AF43`, `CS5`, `VA`, `EF`, `CS6`, `CS7` or a number between 0 and 63."
  }

  validation {
    condition = alltrue([
      for pm in var.dscp_priority_maps : pm.dscp_to == null || try(contains(["unspecified", "CS0", "CS1", "AF11", "AF12", "AF13", "CS2", "AF21", "AF22", "AF23", "CS3", "AF31", "AF32", "AF33", "CS4", "AF41", "AF42", "AF43", "CS5", "VA", "EF", "CS6", "CS7"], pm.dscp_to), false) || try(tonumber(pm.dscp_to) >= 0 && tonumber(pm.dscp_to) <= 63, false)
    ])
    error_message = "`dscp_to`: Allowed values are `unspecified`, `CS0`, `CS1`, `AF11`, `AF12`, `AF13`, `CS2`, `AF21`, `AF22`, `AF23`, `CS3`, `AF31`, `AF32`, `AF33`, `CS4`, `AF41`, `AF42`, `AF43`, `CS5`, `VA`, `EF`, `CS6`, `CS7` or a number between 0 and 63."
  }

  validation {
    condition = alltrue([
      for pm in var.dscp_priority_maps : pm.priority == null || try(contains(["unspecified", "level1", "level2", "level3", "level4", "level5", "level6", ], pm.priority), false)
    ])
    error_message = "`priority`: Allowed values are `unspecified`, `level1`, `level2`, `level3`, `level4`, `level5` or `level6`"
  }

  validation {
    condition = alltrue([
      for pm in var.dscp_priority_maps : pm.dscp_target == null || try(contains(["unspecified", "CS0", "CS1", "AF11", "AF12", "AF13", "CS2", "AF21", "AF22", "AF23", "CS3", "AF31", "AF32", "AF33", "CS4", "AF41", "AF42", "AF43", "CS5", "VA", "EF", "CS6", "CS7"], pm.dscp_target), false) || try(tonumber(pm.dscp_target) >= 0 && tonumber(pm.dscp_target) <= 63, false)
    ])
    error_message = "`dscp_target`: Allowed values are `unspecified`, `CS0`, `CS1`, `AF11`, `AF12`, `AF13`, `CS2`, `AF21`, `AF22`, `AF23`, `CS3`, `AF31`, `AF32`, `AF33`, `CS4`, `AF41`, `AF42`, `AF43`, `CS5`, `VA`, `EF`, `CS6`, `CS7` or a number between 0 and 63."
  }

  validation {
    condition = alltrue([
      for pm in var.dscp_priority_maps : pm.cos_target == "unspecified" || try(pm.cos_target >= 0 && pm.cos_target <= 7, false)
    ])
    error_message = "`cos_target`: Allowed values are `unspecified` or a number between 0 and 7."
  }
}

variable "dot1p_classifiers" {
  description = "QoS Policy DSCP Dot1p Classifiers. Allowed values `dot1p_from`, `dot1p_to` and `cos_target`: `unspecified` or a number between 0 and 7. Allowed values `dscp_target` : `unspecified`, `CS0`, `CS1`, `AF11`, `AF12`, `AF13`, `CS2`, `AF21`, `AF22`, `AF23`, `CS3`, `AF31`, `AF32`, `AF33`, `CS4`, `AF41`, `AF42`, `AF43`, `CS5`, `VA`, `EF`, `CS6`, `CS7` or a number between 0 and 63. Allowed values `priority`: `unspecified`, `level1`, `level2`, `level3`, `level4`, `level5` or `level6`."
  type = list(object({
    dot1p_from  = string
    dot1p_to    = optional(string)
    priority    = optional(string, "level3")
    dscp_target = optional(string, "unspecified")
    cos_target  = optional(string, "unspecified")
  }))
  default = []

  validation {
    condition = alltrue([
      for dot1p in var.dot1p_classifiers : try(dot1p.dot1p_from >= 0 && dot1p.dot1p_from <= 7, false) || dot1p.dot1p_from == "unspecified"
    ])
    error_message = "`dot1p_from`: Allowed values are `unspecified` or a number between 0 and 7."
  }

  validation {
    condition = alltrue([
      for dot1p in var.dot1p_classifiers : dot1p.dot1p_to == null || try(dot1p.dot1p_to >= 0 && dot1p.dot1p_to <= 7, false) || dot1p.dot1p_to == "unspecified"
    ])
    error_message = "`dot1p_to`: Allowed values are `unspecified` or a number between 0 and 7."
  }

  validation {
    condition = alltrue([
      for dot1p in var.dot1p_classifiers : dot1p.priority == null || try(contains(["unspecified", "level1", "level2", "level3", "level4", "level5", "level6", ], dot1p.priority), false)
    ])
    error_message = "`dscp_to`: Allowed values are `unspecified`, `level1`, `level2`, `level3`, `level4`, `level5` or `level6`"
  }

  validation {
    condition = alltrue([
      for dot1p in var.dot1p_classifiers : dot1p.dscp_target == null || try(contains(["unspecified", "CS0", "CS1", "AF11", "AF12", "AF13", "CS2", "AF21", "AF22", "AF23", "CS3", "AF31", "AF32", "AF33", "CS4", "AF41", "AF42", "AF43", "CS5", "VA", "EF", "CS6", "CS7"], dot1p.dscp_target), false) || try(tonumber(dot1p.dscp_target) >= 0 && tonumber(dot1p.dscp_target) <= 63, false)
    ])
    error_message = "`dscp_target`: Allowed values are `unspecified`, `CS0`, `CS1`, `AF11`, `AF12`, `AF13`, `CS2`, `AF21`, `AF22`, `AF23`, `CS3`, `AF31`, `AF32`, `AF33`, `CS4`, `AF41`, `AF42`, `AF43`, `CS5`, `VA`, `EF`, `CS6`, `CS7` or a number between 0 and 63."
  }

  validation {
    condition = alltrue([
      for dot1p in var.dot1p_classifiers : dot1p.cos_target == "unspecified" || try(dot1p.cos_target >= 0 && dot1p.cos_target <= 7, false)
    ])
    error_message = "`cos_target`: Allowed values are `unspecified` or a number between 0 and 7."
  }
}
