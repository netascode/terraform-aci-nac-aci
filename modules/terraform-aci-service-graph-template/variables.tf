variable "tenant" {
  description = "Tenant name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.tenant))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "name" {
  description = "Service graph template name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.name))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "alias" {
  description = "Alias."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.alias))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "description" {
  description = "Description."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", var.description))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, }`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }
}

variable "template_type" {
  description = "Template type. Choices: `FW_TRANS`, `FW_ROUTED`, `ADC_ONE_ARM`, `ADC_TWO_ARM`, `OTHER`, `CLOUD_NATIVE_LB`, `CLOUD_VENDOR_LB`, `CLOUD_NATIVE_FW`, `CLOUD_VENDOR_FW`."
  type        = string
  default     = "OTHER"

  validation {
    condition     = contains(["FW_TRANS", "FW_ROUTED", "ADC_ONE_ARM", "ADC_TWO_ARM", "OTHER", "CLOUD_NATIVE_LB", "CLOUD_VENDOR_LB", "CLOUD_NATIVE_FW", "CLOUD_VENDOR_FW"], var.template_type)
    error_message = "Allowed values are `FW_TRANS`, `FW_ROUTED`, `ADC_ONE_ARM`, `ADC_TWO_ARM`, `OTHER`, `CLOUD_NATIVE_LB`, `CLOUD_VENDOR_LB`, `CLOUD_NATIVE_FW` or `CLOUD_VENDOR_FW`."
  }
}

variable "redirect" {
  description = "Redirect."
  type        = bool
  default     = false
}

variable "share_encapsulation" {
  description = "Share encapsulation."
  type        = bool
  default     = false
}

variable "device_name" {
  description = "L4L7 device name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.device_name))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "device_tenant" {
  description = "L4L7 device tenant name."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.device_tenant))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "device_function" {
  description = "L4L7 device function. Choices: `None`, `GoTo`, `GoThrough`, `L2`, `L1`."
  type        = string
  default     = "GoTo"

  validation {
    condition     = contains(["None", "GoTo", "GoThrough", "L2", "L1"], var.device_function)
    error_message = "Allowed values are `None`, `GoTo`, `GoThrough`, `L2` or `L1`."
  }
}

variable "device_copy" {
  description = "L4L7 device copy function."
  type        = bool
  default     = false
}

variable "device_managed" {
  description = "L4L7 managed device."
  type        = bool
  default     = false
}
