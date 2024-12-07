variable "name" {
  description = "External connectivity policy name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.name))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "route_target" {
  description = "Route target."
  type        = string
  default     = "extended:as2-nn4:5:16"
}

variable "fabric_id" {
  description = "Fabric ID. Minimum value: 1. Maximum value: 65535."
  type        = number
  default     = 1

  validation {
    condition     = var.fabric_id >= 1 && var.fabric_id <= 65535
    error_message = "Minimum value: 1. Maximum value: 65535."
  }
}

variable "site_id" {
  description = "Site ID. Minimum value: 0. Maximum value: 1000."
  type        = number
  default     = 0

  validation {
    condition     = var.site_id >= 0 && var.site_id <= 1000
    error_message = "Minimum value: 0. Maximum value: 1000."
  }
}

variable "peering_type" {
  description = "Peering type. Choices: `full_mesh`, `route_reflector`."
  type        = string
  default     = "full_mesh"

  validation {
    condition     = contains(["full_mesh", "route_reflector"], var.peering_type)
    error_message = "Allowed values are `full_mesh` or `route_reflector`."
  }
}

variable "bgp_password" {
  description = "BGP password."
  type        = string
  default     = null
}

variable "routing_profiles" {
  description = "External routing profiles."
  type = list(object({
    name        = string
    description = optional(string, "")
    subnets     = optional(list(string), [])
  }))
  default = []

  validation {
    condition = alltrue([
      for rp in var.routing_profiles : can(regex("^[a-zA-Z0-9_.:-]{0,64}$", rp.name))
    ])
    error_message = "`name`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for rp in var.routing_profiles : can(regex("^[a-zA-Z0-9\\\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", rp.description))
    ])
    error_message = "`description`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, }`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }
}

variable "data_plane_teps" {
  description = "Data plane TEPs. Allowed values `pod_id`: 1-255."
  type = list(object({
    pod_id = number
    ip     = string
  }))
  default = []

  validation {
    condition = alltrue([
      for tep in var.data_plane_teps : tep.pod_id >= 1 && tep.pod_id <= 255
    ])
    error_message = "`pod_id`: Minimum value: 1. Maximum value: 255."
  }
}

variable "unicast_teps" {
  description = "Unicast TEPs. Allowed values `pod_id`: 1-255."
  type = list(object({
    pod_id = number
    ip     = string
  }))
  default = []

  validation {
    condition = alltrue([
      for tep in var.unicast_teps : tep.pod_id >= 1 && tep.pod_id <= 255
    ])
    error_message = "`pod_id`: Minimum value: 1. Maximum value: 255."
  }
}
