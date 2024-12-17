variable "tenant" {
  description = "Tenant name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.tenant))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "l3out" {
  description = "L3out name."
  type        = string
  default     = null

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.l3out))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "name" {
  description = "Name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.name))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "annotation" {
  description = "Annotation value."
  type        = string
  default     = null

  validation {
    condition     = var.annotation == null || can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.annotation))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "alias" {
  description = "Alias."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.alias))
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

variable "preferred_group" {
  description = "Preferred group membership."
  type        = bool
  default     = false
}

variable "qos_class" {
  description = "QoS class. Choices: `level1`, `level2`, `level3`, `level4`, `level5`, `level6`, `unspecified`."
  type        = string
  default     = "unspecified"

  validation {
    condition     = contains(["level1", "level2", "level3", "level4", "level5", "level6", "unspecified"], var.qos_class)
    error_message = "Allowed values are `level1`, `level2`, `level3`, `level4`, `level5`, `level6` or `unspecified`."
  }
}

variable "target_dscp" {
  description = "Target DSCP. Choices: `CS0`, `CS1`, `AF11`, `AF12`, `AF13`, `CS2`, `AF21`, `AF22`, `AF23`, `CS3`, `AF31`, `AF32`, `AF33`, `CS4`, `AF41`, `AF42`, `AF43`, `CS5`, `VA`, `EF`, `CS6`, `CS7`, `unspecified` or a number between `0` and `63`."
  type        = string
  default     = "unspecified"

  validation {
    condition     = contains(["CS0", "CS1", "AF11", "AF12", "AF13", "CS2", "AF21", "AF22", "AF23", "CS3", "AF31", "AF32", "AF33", "CS4", "AF41", "AF42", "AF43", "CS5", "VA", "EF", "CS6", "CS7", "unspecified"], var.target_dscp) || try(var.target_dscp >= 0 && var.target_dscp <= 63, false)
    error_message = "Allowed values are `CS0`, `CS1`, `AF11`, `AF12`, `AF13`, `CS2`, `AF21`, `AF22`, `AF23`, `CS3`, `AF31`, `AF32`, `AF33`, `CS4`, `AF41`, `AF42`, `AF43`, `CS5`, `VA`, `EF`, `CS6`, `CS7`, `unspecified or a number between `0` and `63`."
  }
}

variable "route_control_profiles" {
  description = "List of route control profiles. Choices `direction`: `import`, `export`."
  type = list(object({
    name      = string
    direction = optional(string, "import")
  }))
  default = []

  validation {
    condition = alltrue([
      for r in var.route_control_profiles : can(regex("^[a-zA-Z0-9_.:-]{0,64}$", r.name))
    ])
    error_message = "`name`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for r in var.route_control_profiles : contains(["import", "export"], r.direction)
    ])
    error_message = "`direction`: Allowed values are `import` and `export`."
  }
}

variable "subnets" {
  description = "List of subnets. Default value `import_route_control`: false. Default value `export_route_control`: false. Default value `shared_route_control`: false. Default value `import_security`: true. Default value `shared_security`: false. Default value `aggregate_import_route_control`: false. Default value `aggregate_export_route_control`: false. Default value `aggregate_shared_route_control`: false. Default value `bgp_route_summarization`: false. Default value `ospf_route_summarization`: false. Default value `eigrp_route_summarization`: false."
  type = list(object({
    name                           = optional(string, "")
    annotation                     = optional(string, null)
    prefix                         = string
    description                    = optional(string, "")
    import_route_control           = optional(bool, false)
    export_route_control           = optional(bool, false)
    shared_route_control           = optional(bool, false)
    import_security                = optional(bool, true)
    shared_security                = optional(bool, false)
    aggregate_import_route_control = optional(bool, false)
    aggregate_export_route_control = optional(bool, false)
    aggregate_shared_route_control = optional(bool, false)
    bgp_route_summarization        = optional(bool, false)
    bgp_route_summarization_policy = optional(string, "")
    ospf_route_summarization       = optional(bool, false)
    eigrp_route_summarization      = optional(bool, false)
    route_control_profiles = optional(list(object({
      name      = string
      direction = optional(string, "import")
    })), [])
  }))
  default = []

  validation {
    condition = alltrue([
      for s in var.subnets : s.name == null || try(can(regex("^[a-zA-Z0-9_.:-]{0,64}$", s.name)), false)
    ])
    error_message = "`name`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for s in var.subnets : s.description == null || try(can(regex("^[a-zA-Z0-9\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", s.description)), false)
    ])
    error_message = "`description`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, }`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }

  validation {
    condition = alltrue([
      for s in var.subnets : alltrue([
        for r in s.route_control_profiles : can(regex("^[a-zA-Z0-9_.:-]{0,64}$", r.name))
      ])
    ])
    error_message = "`route_control_profiles.name`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for s in var.subnets : alltrue([
        for r in s.route_control_profiles : contains(["import", "export"], r.direction)
      ])
    ])
    error_message = "`direction`: Allowed values are `import` and `export`."
  }
}

variable "contract_consumers" {
  description = "List of contract consumers."
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for c in var.contract_consumers : can(regex("^[a-zA-Z0-9_.:-]{0,64}$", c))
    ])
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "contract_providers" {
  description = "List of contract providers."
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for c in var.contract_providers : can(regex("^[a-zA-Z0-9_.:-]{0,64}$", c))
    ])
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "contract_imported_consumers" {
  description = "List of imported contract consumers."
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for c in var.contract_imported_consumers : can(regex("^[a-zA-Z0-9_.:-]{0,64}$", c))
    ])
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}
