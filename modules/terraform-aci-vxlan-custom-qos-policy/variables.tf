variable "name" {
  description = "Vxlan Custom QoS Policy name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.name))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "description" {
  description = "Vxlan Custom QoS Policy description."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9\\\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", var.description))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, }`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }
}

variable "ingress_rules" {
  description = "QoS Policy DSCP Priority Maps. Allowed values `priority`: `unspecified`, `level1`, `level2`, `level3`, `level4`, `level5` or `level6`. Allowed values `exp_from`, `exp_to` and `cos_target`: `unspecified` or a number between 0 and 7. Allowed values `dscp_target` : `unspecified`, `CS0`, `CS1`, `AF11`, `AF12`, `AF13`, `CS2`, `AF21`, `AF22`, `AF23`, `CS3`, `AF31`, `AF32`, `AF33`, `CS4`, `AF41`, `AF42`, `AF43`, `CS5`, `VA`, `EF`, `CS6`, `CS7` or a number between 0 and 63."
  type = list(object({
    priority    = optional(string, "unspecified")
    dscp_from   = string
    dscp_to     = string
    dscp_target = optional(string, "unspecified")
    cos_target  = optional(string, "unspecified")
  }))
  default = []

  validation {
    condition = alltrue([
      for ing in var.ingress_rules : try(contains(["unspecified", "CS0", "CS1", "AF11", "AF12", "AF13", "CS2", "AF21", "AF22", "AF23", "CS3", "AF31", "AF32", "AF33", "CS4", "AF41", "AF42", "AF43", "CS5", "VA", "EF", "CS6", "CS7"], ing.dscp_from), false) || try(tonumber(ing.dscp_from) >= 0 && tonumber(ing.dscp_from) <= 63, false)
    ])
    error_message = "`dscp_from`: Allowed values are `unspecified`, `CS0`, `CS1`, `AF11`, `AF12`, `AF13`, `CS2`, `AF21`, `AF22`, `AF23`, `CS3`, `AF31`, `AF32`, `AF33`, `CS4`, `AF41`, `AF42`, `AF43`, `CS5`, `VA`, `EF`, `CS6`, `CS7` or a number between 0 and 63."
  }

  validation {
    condition = alltrue([
      for ing in var.ingress_rules : try(contains(["unspecified", "CS0", "CS1", "AF11", "AF12", "AF13", "CS2", "AF21", "AF22", "AF23", "CS3", "AF31", "AF32", "AF33", "CS4", "AF41", "AF42", "AF43", "CS5", "VA", "EF", "CS6", "CS7"], ing.dscp_to), false) || try(tonumber(ing.dscp_to) >= 0 && tonumber(ing.dscp_to) <= 63, false)
    ])
    error_message = "`dscp_to`: Allowed values are `unspecified`, `CS0`, `CS1`, `AF11`, `AF12`, `AF13`, `CS2`, `AF21`, `AF22`, `AF23`, `CS3`, `AF31`, `AF32`, `AF33`, `CS4`, `AF41`, `AF42`, `AF43`, `CS5`, `VA`, `EF`, `CS6`, `CS7` or a number between 0 and 63."
  }

  validation {
    condition = alltrue([
      for ing in var.ingress_rules : try(contains(["unspecified", "level1", "level2", "level3", "level4", "level5", "level6", ], ing.priority), false)
    ])
    error_message = "`priority`: Allowed values are `unspecified`, `level1`, `level2`, `level3`, `level4`, `level5` or `level6`"
  }

  validation {
    condition = alltrue([
      for ing in var.ingress_rules : try(contains(["unspecified", "CS0", "CS1", "AF11", "AF12", "AF13", "CS2", "AF21", "AF22", "AF23", "CS3", "AF31", "AF32", "AF33", "CS4", "AF41", "AF42", "AF43", "CS5", "VA", "EF", "CS6", "CS7"], ing.dscp_target), false) || try(tonumber(ing.dscp_target) >= 0 && tonumber(ing.dscp_target) <= 63, false)
    ])
    error_message = "`dscp_target`: Allowed values are `unspecified`, `CS0`, `CS1`, `AF11`, `AF12`, `AF13`, `CS2`, `AF21`, `AF22`, `AF23`, `CS3`, `AF31`, `AF32`, `AF33`, `CS4`, `AF41`, `AF42`, `AF43`, `CS5`, `VA`, `EF`, `CS6`, `CS7` or a number between 0 and 63."
  }

  validation {
    condition = alltrue([
      for ing in var.ingress_rules : ing.cos_target == "unspecified" || try(ing.cos_target >= 0 && ing.cos_target <= 7, false)
    ])
    error_message = "`cos_target`: Allowed values are `unspecified` or a number between 0 and 7."
  }
}

variable "egress_rules" {
  description = "QoS Policy DSCP Dot1p Classifiers. Allowed values `dscp_target` and `cos_target`: `unspecified` or a number between 0 and 7. Allowed values `dscp_from` and `dscp_to` : `unspecified`, `CS0`, `CS1`, `AF11`, `AF12`, `AF13`, `CS2`, `AF21`, `AF22`, `AF23`, `CS3`, `AF31`, `AF32`, `AF33`, `CS4`, `AF41`, `AF42`, `AF43`, `CS5`, `VA`, `EF`, `CS6`, `CS7` or a number between 0 and 63."
  type = list(object({
    dscp_from   = string
    dscp_to     = string
    dscp_target = optional(string, "unspecified")
    cos_target  = optional(string, "unspecified")
  }))
  default = []

  validation {
    condition = alltrue([
      for eg in var.egress_rules : try(contains(["unspecified", "CS0", "CS1", "AF11", "AF12", "AF13", "CS2", "AF21", "AF22", "AF23", "CS3", "AF31", "AF32", "AF33", "CS4", "AF41", "AF42", "AF43", "CS5", "VA", "EF", "CS6", "CS7"], eg.dscp_from), false) || try(tonumber(eg.dscp_from) >= 0 && tonumber(eg.dscp_from) <= 63, false)
    ])
    error_message = "`dscp_from`: Allowed values are `unspecified`, `CS0`, `CS1`, `AF11`, `AF12`, `AF13`, `CS2`, `AF21`, `AF22`, `AF23`, `CS3`, `AF31`, `AF32`, `AF33`, `CS4`, `AF41`, `AF42`, `AF43`, `CS5`, `VA`, `EF`, `CS6`, `CS7` or a number between 0 and 63."
  }

  validation {
    condition = alltrue([
      for eg in var.egress_rules : try(contains(["unspecified", "CS0", "CS1", "AF11", "AF12", "AF13", "CS2", "AF21", "AF22", "AF23", "CS3", "AF31", "AF32", "AF33", "CS4", "AF41", "AF42", "AF43", "CS5", "VA", "EF", "CS6", "CS7"], eg.dscp_to), false) || try(tonumber(eg.dscp_to) >= 0 && tonumber(eg.dscp_to) <= 63, false)
    ])
    error_message = "`dscp_to`: Allowed values are `unspecified`, `CS0`, `CS1`, `AF11`, `AF12`, `AF13`, `CS2`, `AF21`, `AF22`, `AF23`, `CS3`, `AF31`, `AF32`, `AF33`, `CS4`, `AF41`, `AF42`, `AF43`, `CS5`, `VA`, `EF`, `CS6`, `CS7` or a number between 0 and 63."
  }

  validation {
    condition = alltrue([
      for eg in var.egress_rules : try(contains(["unspecified", "CS0", "CS1", "AF11", "AF12", "AF13", "CS2", "AF21", "AF22", "AF23", "CS3", "AF31", "AF32", "AF33", "CS4", "AF41", "AF42", "AF43", "CS5", "VA", "EF", "CS6", "CS7"], eg.dscp_target), false) || try(tonumber(eg.dscp_target) >= 0 && tonumber(eg.dscp_target) <= 63, false)
    ])
    error_message = "`dscp_target`: Allowed values are `unspecified`, `CS0`, `CS1`, `AF11`, `AF12`, `AF13`, `CS2`, `AF21`, `AF22`, `AF23`, `CS3`, `AF31`, `AF32`, `AF33`, `CS4`, `AF41`, `AF42`, `AF43`, `CS5`, `VA`, `EF`, `CS6`, `CS7` or a number between 0 and 63."
  }

  validation {
    condition = alltrue([
      for eg in var.egress_rules : eg.cos_target == "unspecified" || try(eg.cos_target >= 0 && eg.cos_target <= 7, false)
    ])
    error_message = "`cos_target`: Allowed values are `unspecified` or a number between 0 and 7."
  }
}
