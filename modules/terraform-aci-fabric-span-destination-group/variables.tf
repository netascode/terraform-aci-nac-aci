variable "name" {
  description = "Fabric SPAN destination group name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.name))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "description" {
  description = "Fabric SPAN destination group description."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", var.description))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, }`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }
}

variable "ip" {
  description = "Fabric SPAN destination group IP."
  type        = string
  default     = ""
}

variable "source_prefix" {
  description = "Fabric SPAN destination group source prefix."
  type        = string
  default     = ""
}

variable "dscp" {
  description = "Fabric SPAN destination group DSCP. Allowed values are `unspecified`, `CS0`, `CS1`, `AF11`, `AF12`, `AF13`, `CS2`, `AF21`, `AF22`, `AF23`, `CS3`, `AF31`, `AF32`, `AF33`, `CS4`, `AF41`, `AF42`, `AF43`, `CS5`, `VA`, `EF`, `CS6`, `CS7` or a number between 0 and 63."
  type        = string
  default     = "unspecified"

  validation {
    condition     = try(contains(["unspecified", "CS0", "CS1", "AF11", "AF12", "AF13", "CS2", "AF21", "AF22", "AF23", "CS3", "AF31", "AF32", "AF33", "CS4", "AF41", "AF42", "AF43", "CS5", "VA", "EF", "CS6", "CS7"], var.dscp), false) || try(tonumber(var.dscp) >= 0 && tonumber(var.dscp) <= 63, false)
    error_message = "Allowed values are `unspecified`, `CS0`, `CS1`, `AF11`, `AF12`, `AF13`, `CS2`, `AF21`, `AF22`, `AF23`, `CS3`, `AF31`, `AF32`, `AF33`, `CS4`, `AF41`, `AF42`, `AF43`, `CS5`, `VA`, `EF`, `CS6`, `CS7` or a number between 0 and 63."
  }
}

variable "flow_id" {
  description = "Fabric SPAN destination group flow id. Allowed values: 1-1023."
  type        = number
  default     = 1

  validation {
    condition     = var.flow_id >= 1 && var.flow_id <= 1023
    error_message = "Allowed values: 1-1023."
  }
}

variable "mtu" {
  description = "Fabric SPAN destination group MTU. Allowed values: 64-9216."
  type        = number
  default     = 1518

  validation {
    condition     = var.mtu >= 64 && var.mtu <= 9216
    error_message = "Allowed values: 64-9216."
  }
}

variable "ttl" {
  description = "Fabric SPAN destination group TTL. Allowed values: 1-255."
  type        = number
  default     = 64

  validation {
    condition     = var.ttl >= 1 && var.ttl <= 255
    error_message = "Allowed values: 1-255."
  }
}

variable "span_version" {
  description = "Fabric SPAN destination group SPAN version. Allowed values: 1-2."
  type        = number
  default     = 1

  validation {
    condition     = var.span_version >= 1 && var.span_version <= 2
    error_message = "Allowed values: 1-2."
  }
}

variable "enforce_version" {
  description = "Fabric SPAN destination group enforced version flag."
  type        = bool
  default     = false
}

variable "tenant" {
  description = "Fabric SPAN destination group tenant name."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.tenant))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "application_profile" {
  description = "Fabric SPAN destination group application profile name."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.application_profile))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "endpoint_group" {
  description = "Fabric SPAN destination group endpoint group name."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.endpoint_group))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}
