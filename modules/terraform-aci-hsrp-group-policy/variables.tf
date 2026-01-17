variable "tenant" {
  description = "Tenant name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.tenant))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "name" {
  description = "HSRP group policy name."
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
    condition     = can(regex("^[a-zA-Z0-9\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", var.description))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, }`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }
}

variable "preempt" {
  description = "Enable preemption. Allows a higher-priority HSRP router to become the active router."
  type        = bool
  default     = false
}

variable "hello_interval" {
  description = "Hello interval in milliseconds. Time between hello packets sent by HSRP."
  type        = number
  default     = 3000

  validation {
    condition     = var.hello_interval >= 250 && var.hello_interval <= 254000
    error_message = "Allowed values are between 250 and 254000 milliseconds."
  }
}

variable "hold_interval" {
  description = "Hold interval in milliseconds. Time before declaring active router down."
  type        = number
  default     = 10000

  validation {
    condition     = var.hold_interval >= 750 && var.hold_interval <= 255000
    error_message = "Allowed values are between 750 and 255000 milliseconds."
  }
}

variable "auth_key" {
  description = "Authentication key for HSRP packets. Used for MD5 authentication."
  type        = string
  default     = ""
  sensitive   = true

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,127}$", var.auth_key)) || var.auth_key == ""
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 127."
  }
}

variable "preempt_delay_min" {
  description = "Preempt minimum delay in seconds. Minimum time to wait before preempting."
  type        = number
  default     = 0

  validation {
    condition     = var.preempt_delay_min >= 0 && var.preempt_delay_min <= 3600
    error_message = "Allowed values are between 0 and 3600 seconds."
  }
}

variable "preempt_delay_reload" {
  description = "Preempt reload delay in seconds. Delay after reload before preempting."
  type        = number
  default     = 0

  validation {
    condition     = var.preempt_delay_reload >= 0 && var.preempt_delay_reload <= 3600
    error_message = "Allowed values are between 0 and 3600 seconds."
  }
}

variable "preempt_delay_max" {
  description = "Preempt synchronization delay in seconds. Delay for IP redundancy clients to be ready."
  type        = number
  default     = 0

  validation {
    condition     = var.preempt_delay_max >= 0 && var.preempt_delay_max <= 3600
    error_message = "Allowed values are between 0 and 3600 seconds."
  }
}

variable "priority" {
  description = "HSRP priority. Higher value is preferred for active router selection."
  type        = number
  default     = 100

  validation {
    condition     = var.priority >= 0 && var.priority <= 255
    error_message = "Allowed values are between 0 and 255."
  }
}

variable "timeout" {
  description = "Timeout in seconds for HSRP session."
  type        = number
  default     = 0

  validation {
    condition     = var.timeout >= 0 && var.timeout <= 3600
    error_message = "Allowed values are between 0 and 3600 seconds."
  }
}

variable "auth_type" {
  description = "HSRP version type. Options: simple (HSRPv1) or md5 (HSRPv2 with MD5 authentication)."
  type        = string
  default     = "simple"

  validation {
    condition     = contains(["simple", "md5"], var.auth_type)
    error_message = "Allowed values are `simple` or `md5`."
  }
}
