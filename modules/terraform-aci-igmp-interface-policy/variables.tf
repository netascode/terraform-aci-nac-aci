variable "tenant" {
  description = "Tenant name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.tenant))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "name" {
  description = "IGMP interface policy name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.name))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "description" {
  description = "IGMP interface policy description."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", var.description))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, }`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }
}

variable "grp_timeout" {
  description = "IGMP interface policy group timeout. Allowed values between 3-65535."
  type        = number
  default     = 260

  validation {
    condition     = var.grp_timeout >= 3 && var.grp_timeout <= 65535
    error_message = "Allowed values between 3-65535."
  }
}

variable "allow_v3_asm" {
  description = "IGMP interface policy flag for Any-source multicast (ASM) v3."
  type        = bool
  default     = false
}

variable "fast_leave" {
  description = "IGMP interface policy flag for fast leave."
  type        = bool
  default     = false
}

variable "report_link_local_groups" {
  description = "IGMP interface policy flag for link local groups report."
  type        = bool
  default     = false
}

variable "last_member_count" {
  description = "IGMP interface policy last member query count. Allowed values between 1-5."
  type        = number
  default     = 2

  validation {
    condition     = var.last_member_count >= 1 && var.last_member_count <= 5
    error_message = "Allowed values between 1-5."
  }
}

variable "last_member_response_time" {
  description = "IGMP interface policy last member response time. Allowed values between 1-25."
  type        = number
  default     = 1

  validation {
    condition     = var.last_member_response_time >= 1 && var.last_member_response_time <= 25
    error_message = "Allowed values between 1-25."
  }
}

variable "querier_timeout" {
  description = "IGMP interface policy querier timeout. Allowed values between 1-255."
  type        = number
  default     = 255

  validation {
    condition     = var.querier_timeout >= 1 && var.querier_timeout <= 255
    error_message = "Allowed values between 1-255."
  }
}

variable "query_interval" {
  description = "IGMP interface policy querier interval. Allowed values between 1-18000."
  type        = number
  default     = 125

  validation {
    condition     = var.query_interval >= 1 && var.query_interval <= 18000
    error_message = "Allowed values between 1-18000."
  }
}

variable "robustness_variable" {
  description = "IGMP interface policy robustness factor. Allowed values between 1-7."
  type        = number
  default     = 2

  validation {
    condition     = var.robustness_variable >= 1 && var.robustness_variable <= 7
    error_message = "Allowed values between 1-7."
  }
}

variable "query_response_interval" {
  description = "IGMP interface policy query response interval. Allowed values between 1-25."
  type        = number
  default     = 25

  validation {
    condition     = var.query_response_interval >= 1 && var.query_response_interval <= 25
    error_message = "Allowed values between 1-25."
  }
}

variable "startup_query_count" {
  description = "IGMP interface policy startup query count. Allowed values between 1-10."
  type        = number
  default     = 2

  validation {
    condition     = var.startup_query_count >= 1 && var.startup_query_count <= 10
    error_message = "Allowed values between 1-10."
  }
}

variable "startup_query_interval" {
  description = "IGMP interface policy startup query interval. Allowed values between 1-10."
  type        = number
  default     = 31

  validation {
    condition     = var.startup_query_interval >= 1 && var.startup_query_interval <= 18000
    error_message = "Allowed values between 1-18000."
  }
}

variable "version_" {
  description = "IGMP interface policy startup query count. Allowed values `v2` or `v3`."
  type        = string
  default     = "v2"

  validation {
    condition     = contains(["v2", "v3"], var.version_)
    error_message = "Allowed values `v2` or `v3`."
  }
}

variable "report_policy_multicast_route_map" {
  description = "IGMP interface policy report multicast route-map."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.report_policy_multicast_route_map))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "static_report_multicast_route_map" {
  description = "IGMP interface policy static report multicast route-map."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.static_report_multicast_route_map))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "max_mcast_entries" {
  description = "IGMP interface policy maximum number of multicast entries. Allowed values 1-4294967295 or `unlimited`."
  type        = string
  default     = "unlimited"

  validation {
    condition     = var.max_mcast_entries == "unlimited" || try(tonumber(var.max_mcast_entries) >= 1 && tonumber(var.max_mcast_entries) <= 4294967295, false)
    error_message = "Allowed values 1-4294967295 or `unlimited`."
  }
}

variable "reserved_mcast_entries" {
  description = "IGMP interface policy number of reserved multicast entries. Allowed values 0-4294967295 or `undefined`."
  type        = string
  default     = "undefined"

  validation {
    condition     = var.reserved_mcast_entries == "undefined" || try(tonumber(var.reserved_mcast_entries) >= 0 && tonumber(var.reserved_mcast_entries) <= 4294967295, false)
    error_message = "Allowed values 0-4294967295 or `undefined`."
  }
}

variable "state_limit_multicast_route_map" {
  description = "IGMP interface policy state limit multicast route-map."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.state_limit_multicast_route_map))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}
