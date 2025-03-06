variable "tenant" {
  description = "Tenant name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.tenant))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "name" {
  description = "OSPF timer policy name."
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

variable "reference_bandwidth" {
  description = "Reference bandwidth. Minimum value: `1`. Maximum value: `4000000`."
  type        = number
  default     = 40000

  validation {
    condition     = var.reference_bandwidth >= 1 && var.reference_bandwidth <= 4000000
    error_message = "Minimum value: `1`. Maximum value: `4000000`."
  }
}

variable "distance" {
  description = "Distance. Minimum value: `1`. Maximum value: `255`."
  type        = number
  default     = 110

  validation {
    condition     = var.distance >= 1 && var.distance <= 255
    error_message = "Minimum value: `1`. Maximum value: `255`."
  }
}

variable "max_ecmp" {
  description = "Max ECMP. Minimum value: `1`. Maximum value: `64`."
  type        = number
  default     = 8

  validation {
    condition     = var.max_ecmp >= 1 && var.max_ecmp <= 64
    error_message = "Minimum value: `1`. Maximum value: `64`."
  }
}

variable "spf_init_interval" {
  description = "SPF init interval. Minimum value: `1`. Maximum value: `600000`."
  type        = number
  default     = 200

  validation {
    condition     = var.spf_init_interval >= 1 && var.spf_init_interval <= 600000
    error_message = "Minimum value: `1`. Maximum value: `600000`."
  }
}

variable "spf_hold_interval" {
  description = "SPF hold interval. Minimum value: `1`. Maximum value: `600000`."
  type        = number
  default     = 1000

  validation {
    condition     = var.spf_hold_interval >= 1 && var.spf_hold_interval <= 600000
    error_message = "Minimum value: `1`. Maximum value: `600000`."
  }
}

variable "spf_max_interval" {
  description = "SPF max interval. Minimum value: `1`. Maximum value: `600000`."
  type        = number
  default     = 5000

  validation {
    condition     = var.spf_max_interval >= 1 && var.spf_max_interval <= 600000
    error_message = "Minimum value: `1`. Maximum value: `600000`."
  }
}

variable "max_lsa_reset_interval" {
  description = "Max LSA reset interval. Minimum value: `1`. Maximum value: `1440`."
  type        = number
  default     = 10

  validation {
    condition     = var.max_lsa_reset_interval >= 1 && var.max_lsa_reset_interval <= 1440
    error_message = "Minimum value: `1`. Maximum value: `1440`."
  }
}

variable "max_lsa_sleep_count" {
  description = "Max LSA sleep count. Minimum value: `1`. Maximum value: `4294967295`."
  type        = number
  default     = 5

  validation {
    condition     = var.max_lsa_sleep_count >= 1 && var.max_lsa_sleep_count <= 4294967295
    error_message = "Minimum value: `1`. Maximum value: `4294967295`."
  }
}

variable "max_lsa_sleep_interval" {
  description = "Max LSA sleep interval. Minimum value: `1`. Maximum value: `1440`."
  type        = number
  default     = 5

  validation {
    condition     = var.max_lsa_sleep_interval >= 1 && var.max_lsa_sleep_interval <= 1440
    error_message = "Minimum value: `1`. Maximum value: `1440`."
  }
}

variable "lsa_arrival_interval" {
  description = "LSA arrival interval. Minimum value: `10`. Maximum value: `600000`."
  type        = number
  default     = 1000

  validation {
    condition     = var.lsa_arrival_interval >= 10 && var.lsa_arrival_interval <= 600000
    error_message = "Minimum value: `10`. Maximum value: `600000`."
  }
}

variable "lsa_group_pacing_interval" {
  description = "LSA group pacing interval. Minimum value: `1`. Maximum value: `1800`."
  type        = number
  default     = 10

  validation {
    condition     = var.lsa_group_pacing_interval >= 1 && var.lsa_group_pacing_interval <= 1800
    error_message = "Minimum value: `1`. Maximum value: `1800`."
  }
}

variable "lsa_hold_interval" {
  description = "LSA hold interval. Minimum value: `50`. Maximum value: `30000`."
  type        = number
  default     = 5000

  validation {
    condition     = var.lsa_hold_interval >= 50 && var.lsa_hold_interval <= 30000
    error_message = "Minimum value: `50`. Maximum value: `30000`."
  }
}

variable "lsa_start_interval" {
  description = "LSA start interval. Minimum value: `0`. Maximum value: `5000`."
  type        = number
  default     = 0

  validation {
    condition     = var.lsa_start_interval >= 0 && var.lsa_start_interval <= 5000
    error_message = "Minimum value: `0`. Maximum value: `5000`."
  }
}

variable "lsa_max_interval" {
  description = "LSA max interval. Minimum value: `50`. Maximum value: `30000`."
  type        = number
  default     = 5000

  validation {
    condition     = var.lsa_max_interval >= 50 && var.lsa_max_interval <= 30000
    error_message = "Minimum value: `50`. Maximum value: `30000`."
  }
}

variable "max_lsa_num" {
  description = "Max LSA number."
  type        = number
  default     = 20000
}

variable "max_lsa_threshold" {
  description = "Max LSA threshold. Minimum value: `1`. Maximum value: `100`."
  type        = number
  default     = 75

  validation {
    condition     = var.max_lsa_threshold >= 1 && var.max_lsa_threshold <= 100
    error_message = "Minimum value: `1`. Maximum value: `100`."
  }
}

variable "max_lsa_action" {
  description = "Max LSA action. Choices: `reject`, `log`."
  type        = string
  default     = "reject"

  validation {
    condition     = contains(["reject", "log"], var.max_lsa_action)
    error_message = "Allowed values are `reject` or `log`."
  }
}

variable "graceful_restart" {
  description = "Graceful restart."
  type        = bool
  default     = false
}

variable "router_id_lookup" {
  description = "Router ID lookup."
  type        = bool
  default     = false
}

variable "prefix_suppression" {
  description = "Prefix suppression."
  type        = bool
  default     = false
}
