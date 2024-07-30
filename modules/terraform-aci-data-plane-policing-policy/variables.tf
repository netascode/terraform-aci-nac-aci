variable "name" {
  type        = string
  description = "Name of Data Plane Policing policy."

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.name))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "description" {
  description = "Data Plane Policing policy description."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", var.description))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, }`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }
}

variable "admin_state" {
  type        = bool
  default     = true
  description = "Administrative state of Data Plane Policing policy."
}

variable "policer_policy_type" {
  type        = string
  description = "Type of policy. Allowed Values: `access` or `tenant`"
  default = "access"

  validation {
    condition     = try(contains(["access", "tenant"], var.policer_policy_type), false)
    error_message = "Allowed Values: `access` or `tenant`."
  }
}

variable "type" {
  type        = string
  description = "Policer Type. Allowed Values: `1R2C` or `2R3C`."
  default     = "1R2C"

  validation {
    condition     = try(contains(["1R2C", "2R3C"], var.type), false)
    error_message = "Allowed Values: `1R2C` or `2R3C`."
  }
}

variable "mode" {
  type        = string
  description = "Policer Mode.  Allowed Values: `bit` or `packet`."
  default     = "bit"

  validation {
    condition     = try(contains(["bit", "packet"], var.mode), false)
    error_message = "Allowed Values: `bit` or `packet`."
  }
}

variable "sharing_mode" {
  type        = string
  description = "Policer sharing mode. Allowed Values: `shared` or `dedicated`."
  default     = "dedicated"

  validation {
    condition     = try(contains(["shared", "dedicated"], var.sharing_mode), false)
    error_message = "Allowed Values: `shared` or `dedicated`."
  }
}

variable "pir" {
  type        = number
  description = "Peak Information Rate (2R3C policer only). Allowed Values: A number between 0 and 4,398,046,510,080."

  validation {
    condition     = var.pir == null || try(var.pir >= 0 && var.pir <= 4398046510080, false)
    error_message = "Allowed Values: A number between `0` and `4,398,046,510,080`."
  }
}

variable "pir_unit" {
  type        = string
  description = "Peak Rate Unit. Allowed Values: `unspecified`, `bits`, `kilo`, `mega`, `giga`."
  default     = "unspecified"

  validation {
    condition     = var.pir_unit == null || try(contains(["unspecified", "bits", "kilo", "mega", "giga"], var.pir_unit), false)
    error_message = "Allowed Values: `unspecified`, `bits`, `kilo`, `mega`, `giga`."
  }
}

variable "rate" {
  type        = number
  description = "Committed Information Rate. Allowed Values: A number between 0 and 4,398,046,510,080."

  validation {
    condition     = try(var.rate >= 0 && var.rate <= 4398046510080, false)
    error_message = "Allowed Values: A number between `0` and `4,398,046,510,080`."
  }
}

variable "rate_unit" {
  type        = string
  description = "Committed Rate Unit. Allowed Values: `unspecified`, `bits`, `kilo`, `mega`, `giga`."
  default     = "unspecified"

  validation {
    condition     = try(contains(["unspecified", "bits", "kilo", "mega", "giga"], var.rate_unit), false)
    error_message = "Allowed Values: `unspecified`, `bits`, `kilo`, `mega`, `giga`."
  }
}

variable "burst_excessive" {
  type        = string
  description = "Excessive burst size (2R3C policer only). Allowed Values: `unspecified`, or a number between 0 and 549,755,813,760."
  default     = "unspecified"

  validation {
    condition     = var.burst_excessive == null || try(contains(["unspecified"], var.burst_excessive), false) || try(tonumber(var.burst_excessive) >= 0 && tonumber(var.burst_excessive) <= 549755813760, false)
    error_message = "Allowed Values: `unspecified`, or a number between `0` and `549,755,813,760`."
  }
}

variable "burst_excessive_unit" {
  type        = string
  description = "Excessive Burst unit.  Allowed values: `unspecified`, `byte`, `kilo`, `mega`, `giga`, `msec`, `usec`."
  default     = "unspecified"

  validation {
    condition     = var.burst_excessive_unit == null || try(contains(["unspecified", "byte", "kilo", "mega", "giga", "msec", "usec"], var.burst_excessive_unit), false)
    error_message = "Allowed values: `unspecified`, `byte`, `kilo`, `mega`, `giga`, `msec`, `usec`."
  }
}

variable "burst" {
  type        = string
  description = "Committed burst size. Allowed Values: `unspecified`, or a number between 0 and 549,755,813,760."
  default     = "unspecified"

  validation {
    condition     = try(contains(["unspecified"], var.burst), false) || try(tonumber(var.burst) >= 0 && tonumber(var.burst) <= 549755813760, false)
    error_message = "Allowed Values: `unspecified`, or a number between `0` and `549,755,813,760`."
  }
}

variable "burst_unit" {
  type        = string
  description = "Burst unit.  Allowed values: `unspecified`, `byte`, `kilo`, `mega`, `giga`, `msec`, `usec`."
  default     = "unspecified"

  validation {
    condition     = try(contains(["unspecified", "byte", "kilo", "mega", "giga", "msec", "usec"], var.burst_unit), false)
    error_message = "Allowed values: `unspecified`, `byte`, `kilo`, `mega`, `giga`, `msec`, `usec`."
  }
}

variable "conform_action" {
  type        = string
  description = "Conform Action. Allowed Values: `transmit`, `drop`, or `mark`."
  default     = "transmit"

  validation {
    condition = try(contains(["transmit", "drop", "mark"], var.conform_action), false)
    error_message = "Allowed Values: `transmit`, `drop`, or `mark`."
  }
}

variable "conform_mark_cos" {
  type        = string
  description = "Conform Mark COS.  Allowed Values: `unspecified` or a number between 0 and 7."
  default     = "unspecified"

  validation {
    condition     = var.conform_mark_cos == "unspecified" || try(tonumber(var.conform_mark_cos) >= 0 && tonumber(var.conform_mark_cos) <= 7, false)
    error_message = "Allowed Values: `unspecified` or a number between 0 and 7."
  }
}

variable "conform_mark_dscp" {
  type        = string
  description = "Conform Mark Dscp. Allowed values are `unspecified`, `CS0`, `CS1`, `AF11`, `AF12`, `AF13`, `CS2`, `AF21`, `AF22`, `AF23`, `CS3`, `AF31`, `AF32`, `AF33`, `CS4`, `AF41`, `AF42`, `AF43`, `CS5`, `VA`, `EF`, `CS6`, `CS7` or a number between 0 and 63."
  default     = "unspecified"

  validation {
    condition = var.conform_mark_dscp == null || try(contains(["unspecified", "CS0", "CS1", "AF11", "AF12", "AF13", "CS2", "AF21", "AF22", "AF23", "CS3", "AF31", "AF32", "AF33", "CS4", "AF41", "AF42", "AF43", "CS5", "VA", "EF", "CS6", "CS7"], var.conform_mark_dscp), false) || try(tonumber(var.conform_mark_dscp) >= 0 && tonumber(var.conform_mark_dscp) <= 63, false)
    error_message = "Allowed values are `unspecified`, `CS0`, `CS1`, `AF11`, `AF12`, `AF13`, `CS2`, `AF21`, `AF22`, `AF23`, `CS3`, `AF31`, `AF32`, `AF33`, `CS4`, `AF41`, `AF42`, `AF43`, `CS5`, `VA`, `EF`, `CS6`, `CS7` or a number between 0 and 63."
  }
}

variable "exceed_action" {
  type        = string
  description = "Exceed Action. Allowed Values: `transmit`, `drop`, or `mark`."
  default     = "transmit"

  validation {
    condition = try(contains(["transmit", "drop", "mark"], var.exceed_action), false)
    error_message = "Allowed Values: `transmit`, `drop`, or `mark`."
  }
}

variable "exceed_mark_cos" {
  type        = string
  description = "Exceed Mark COS.  Allowed Values: `unspecified` or a number between 0 and 7."
  default     = "unspecified"

  validation {
    condition     = var.exceed_mark_cos == "unspecified" || try(tonumber(var.exceed_mark_cos) >= 0 && tonumber(var.exceed_mark_cos) <= 7, false)
    error_message = "Allowed Values: `unspecified` or a number between 0 and 7."
  }
}

variable "exceed_mark_dscp" {
  type        = string
  description = "Exceed Mark Dscp. Allowed values are `unspecified`, `CS0`, `CS1`, `AF11`, `AF12`, `AF13`, `CS2`, `AF21`, `AF22`, `AF23`, `CS3`, `AF31`, `AF32`, `AF33`, `CS4`, `AF41`, `AF42`, `AF43`, `CS5`, `VA`, `EF`, `CS6`, `CS7` or a number between 0 and 63."
  default     = "unspecified"

  validation {
    condition = var.exceed_mark_dscp == null || try(contains(["unspecified", "CS0", "CS1", "AF11", "AF12", "AF13", "CS2", "AF21", "AF22", "AF23", "CS3", "AF31", "AF32", "AF33", "CS4", "AF41", "AF42", "AF43", "CS5", "VA", "EF", "CS6", "CS7"], var.exceed_mark_dscp), false) || try(tonumber(var.exceed_mark_dscp) >= 0 && tonumber(var.exceed_mark_dscp) <= 63, false)
    error_message = "Allowed values are `unspecified`, `CS0`, `CS1`, `AF11`, `AF12`, `AF13`, `CS2`, `AF21`, `AF22`, `AF23`, `CS3`, `AF31`, `AF32`, `AF33`, `CS4`, `AF41`, `AF42`, `AF43`, `CS5`, `VA`, `EF`, `CS6`, `CS7` or a number between 0 and 63."
  }
}

variable "violate_action" {
  type        = string
  description = "Violate Action. Allowed Values: `transmit`, `drop`, or `mark`."
  default     = "transmit"

  validation {
    condition = try(contains(["transmit", "drop", "mark"], var.violate_action), false)
    error_message = "Allowed Values: `transmit`, `drop`, or `mark`."
  }
}

variable "violate_mark_cos" {
  type        = string
  description = "Violate Mark COS.  Allowed Values: `unspecified` or a number between 0 and 7."
  default     = "unspecified"

  validation {
    condition     = var.violate_mark_cos == null || var.violate_mark_cos == "unspecified" || try(tonumber(var.violate_mark_cos) >= 0 && tonumber(var.violate_mark_cos) <= 7, false)
    error_message = "Allowed Values: `unspecified` or a number between 0 and 7."
  }
}

variable "violate_mark_dscp" {
  type        = string
  description = "Violate Mark Dscp. Allowed values are `unspecified`, `CS0`, `CS1`, `AF11`, `AF12`, `AF13`, `CS2`, `AF21`, `AF22`, `AF23`, `CS3`, `AF31`, `AF32`, `AF33`, `CS4`, `AF41`, `AF42`, `AF43`, `CS5`, `VA`, `EF`, `CS6`, `CS7` or a number between 0 and 63."
  default     = "unspecified"

  validation {
    condition = var.violate_mark_dscp == null || try(contains(["unspecified", "CS0", "CS1", "AF11", "AF12", "AF13", "CS2", "AF21", "AF22", "AF23", "CS3", "AF31", "AF32", "AF33", "CS4", "AF41", "AF42", "AF43", "CS5", "VA", "EF", "CS6", "CS7"], var.violate_mark_dscp), false) || try(tonumber(var.violate_mark_dscp) >= 0 && tonumber(var.violate_mark_dscp) <= 63, false)
    error_message = "Allowed values are `unspecified`, `CS0`, `CS1`, `AF11`, `AF12`, `AF13`, `CS2`, `AF21`, `AF22`, `AF23`, `CS3`, `AF31`, `AF32`, `AF33`, `CS4`, `AF41`, `AF42`, `AF43`, `CS5`, `VA`, `EF`, `CS6`, `CS7` or a number between 0 and 63."
  }
}