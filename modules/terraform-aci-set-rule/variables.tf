variable "tenant" {
  description = "Tenant name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.tenant))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "name" {
  description = "Set rule name."
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

variable "community" {
  description = "Community."
  type        = string
  default     = ""
}

variable "community_mode" {
  description = "Community mode. Choices: `append`, `replace`."
  type        = string
  default     = "append"

  validation {
    condition     = contains(["append", "replace"], var.community_mode)
    error_message = "Allowed values are `append` or `replace`."
  }
}


variable "tag" {
  description = "Tag. Allowed values `tag`: 0-4294967295."
  type        = number
  default     = null

  validation {
    condition     = coalesce(var.tag, 0) >= 0 && coalesce(var.tag, 4294967295) <= 4294967295
    error_message = "Minimum value: `0`. Maximum value: `4294967295`."
  }
}

variable "dampening" {
  description = "Dampening."
  type        = bool
  default     = false
}

variable "dampening_half_life" {
  description = "Dampening Half Life. Allowed values `dampening_half_life`: `1-60`."
  type        = number
  default     = 15
  validation {
    condition     = var.dampening_half_life >= 1 && var.dampening_half_life <= 60
    error_message = "`dampening_half_life` minimum value: `1`. Maximum value: `60`."
  }
}

variable "dampening_max_suppress_time" {
  description = "Dampening Max Supress. Allowed values `dampening_max_suppress_time`: `1-255`."
  type        = number
  default     = 60
  validation {
    condition     = var.dampening_max_suppress_time >= 1 && var.dampening_max_suppress_time <= 255
    error_message = "`dampening_max_suppress_time` minimum value: `1`. Maximum value: `255`."
  }
}


variable "dampening_reuse_limit" {
  description = "Dampening Re-use Limit. Allowed values `dampening_reuse_limit`: `1-2000`."
  type        = number
  default     = 750
  validation {
    condition     = var.dampening_reuse_limit >= 1 && var.dampening_reuse_limit <= 2000
    error_message = "`dampening_reuse_limit` minimum value: `1`. Maximum value: `2000`."
  }
}

variable "dampening_suppress_limit" {
  description = "Dampening Supress Limit. Allowed values `dampening_suppress_limit`: `1-2000`."
  type        = number
  default     = 2000
  validation {
    condition     = var.dampening_suppress_limit >= 1 && var.dampening_suppress_limit <= 2000
    error_message = "`dampening_suppress_limit` minimum value: `1`. Maximum value: `2000`."
  }
}

variable "weight" {
  description = "Weight. Allowed values `weight`: 0-65535."
  type        = number
  default     = null

  validation {
    condition     = coalesce(var.weight, 0) >= 0 && coalesce(var.weight, 65535) <= 65535
    error_message = "Minimum value: `0`. Maximum value: `65535`."
  }
}

variable "next_hop" {
  description = "Next Hop IP."
  type        = string
  default     = ""

}

variable "preference" {
  description = "Preference. Allowed values `preference`: 0-4294967295."
  type        = number
  default     = null

  validation {
    condition     = coalesce(var.preference, 0) >= 0 && coalesce(var.preference, 65535) <= 65535
    error_message = "Minimum value: `0`. Maximum value: `4294967295`."
  }
}

variable "metric" {
  description = "Metric. Allowed values `metric`: 0-4294967295."
  type        = number
  default     = null

  validation {
    condition     = coalesce(var.metric, 0) >= 0 && coalesce(var.metric, 65535) <= 65535
    error_message = "Minimum value: `0`. Maximum value: `4294967295`."
  }
}

variable "metric_type" {
  description = "Metric Type. Choice `metric_type`: `ospf-type1` or `ospf-type1`."
  type        = string
  default     = ""

  validation {
    condition     = contains(["ospf-type1", "ospf-type2", ""], var.metric_type)
    error_message = "Valid values are `ospf-type1` or `ospf-type2`."
  }
}


variable "additional_communities" {
  description = "Additional communities."
  type = list(object({
    community   = string
    description = optional(string, "")
  }))
  default = []

  validation {
    condition = alltrue([
      for c in var.additional_communities : c.description == null || can(regex("^[a-zA-Z0-9\\\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", c.description))
    ])
    error_message = "`description`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, }`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }
}

variable "set_as_paths" {
  description = "AS-Path Set List."
  type = list(object({
    criteria = optional(string, "prepend")
    count    = optional(number, 1)
    asns = list(object({
      order      = optional(number, 0)
      asn_number = number
    }))
  }))
  default = []

  validation {
    condition = alltrue([
      for c in var.set_as_paths : c.criteria == null || contains(["prepend", "prepend-last-as"], c.criteria)
    ])
    error_message = "Valid values for `criteria` are `prepend` or `prepend-last-as`."
  }

  validation {
    condition = alltrue([
      for c in var.set_as_paths : c.count == null || c.count >= 0 && c.count <= 10
    ])
    error_message = "`count` minimum value: `0`. Maximum value: `10`."
  }

  validation {
    condition = alltrue(flatten([
      for c in var.set_as_paths : [
        for a in c.asns : a.order == null || try(a.order >= 0 && a.order <= 31, false)
    ]]))
    error_message = "`order` minimum value: `0`. Maximum value: `31`."
  }
}

variable "next_hop_propagation" {
  description = "Next Hop Propagation."
  type        = bool
  default     = false
}

variable "multipath" {
  description = "Multipath."
  type        = bool
  default     = false
}

variable "external_endpoint_group" {
  description = "External endpoint group name."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.external_endpoint_group))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "external_endpoint_group_l3out" {
  description = "External endpoint group l3out name."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.external_endpoint_group_l3out))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "external_endpoint_group_tenant" {
  description = "External endpoint group tenant name."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.external_endpoint_group_tenant))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}
