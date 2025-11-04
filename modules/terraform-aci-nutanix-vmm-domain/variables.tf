variable "name" {
  description = "Nutanix VMM domain name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.name))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "access_mode" {
  description = "Access mode. Choices: `read-only`, `read-write`."
  type        = string
  default     = "read-write"

  validation {
    condition     = contains(["read-only", "read-write"], var.access_mode)
    error_message = "Allowed values are `read-only` or `read-write`. Default is `read-write`."
  }
}

variable "vlan_pool" {
  description = "Vlan pool name."
  type        = string
  default     = null

  validation {
    condition     = var.vlan_pool == null || can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.vlan_pool))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "allocation" {
  description = "Vlan pool allocation mode. Choices: `static`, `dynamic`."
  type        = string
  default     = "dynamic"

  validation {
    condition     = contains(["static", "dynamic"], var.allocation)
    error_message = "Allowed values are `static` or `dynamic`. Default is `dynamic`."
  }
}

variable "custom_vswitch_name" {
  description = "Custom vSwitch name."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,512}$", var.custom_vswitch_name))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "security_domains" {
  description = "Security domains associated to Nutanix VMM domain"
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for s in var.security_domains : can(regex("^[a-zA-Z0-9_.:-]{0,64}$", s))
    ])
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "credential_policies" {
  description = "List of Nutanix credentials."
  type = list(object({
    name     = string
    username = string
    password = string
  }))
  default = []

  validation {
    condition = alltrue([
      for c in var.credential_policies : can(regex("^[a-zA-Z0-9_.:-]{0,64}$", c.name))
    ])
    error_message = "Allowed characters `name`: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for c in var.credential_policies : can(regex("^[a-zA-Z0-9\\\\\\!#$%()*,-./:;@ _{|}~?&+]{1,128}$", c.username))
    ])
    error_message = "Allowed characters `username`: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, `_`, `{`, `|`, `}`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }
}

variable "controller_profile" {
  description = "Controller Profile. Only one Controller Profile is allowed per Nutanix VMM domain. Default AOS version is `unknown`. Default statistics collection is `false`."
  type = map(object({
    name        = string
    hostname_ip = string
    datacenter  = string
    aos_version = optional(string, "unknown")
    credentials = string
    statistics  = optional(bool, false)
  }))
  default = {}

  validation {
    condition = alltrue([
      for v in values(var.controller_profile) : can(regex("^[a-zA-Z0-9_.:-]{0,64}$", v.name))
    ])
    error_message = "Allowed characters `name`: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for v in values(var.controller_profile) : can(regex("^[a-zA-Z0-9:][a-zA-Z0-9.:-]{0,254}$", v.hostname_ip))
    ])
    error_message = "Allowed characters `hostname_ip`: `a`-`z`, `A`-`Z`, `0`-`9`, `.`, `:`, `-`. Maximum characters: 254."
  }

  validation {
    condition = alltrue([
      for v in values(var.controller_profile) : can(regex("^.{0,512}$", v.datacenter))
    ])
    error_message = "Maximum characters `datacenter`: 512."
  }

  validation {
    condition = alltrue([
      for v in values(var.controller_profile) : v.aos_version == null || contains(["unknown", "6.5", "6.6"], v.aos_version)
    ])
    error_message = "`aos_version`: Allowed values are `unknown`, `6.5`, `6.6`. Default is `unknown`."
  }

  validation {
    condition = alltrue([
      for v in values(var.controller_profile) : v.credentials == null || can(regex("^[a-zA-Z0-9_.:-]{0,64}$", v.credentials))
    ])
    error_message = "Allowed characters `credentials`: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "cluster_controller" {
  description = "Cluster Controller. Only one Cluster Controller is allowed per Controller Profile. Default port is `0`."
  type = map(object({
    name               = string
    hostname_ip        = string
    cluster_name       = string
    credentials        = string
    port               = optional(number, 0)
    controller_profile = string
  }))
  default = {}

  validation {
    condition = alltrue([
      for v in values(var.cluster_controller) : can(regex("^[a-zA-Z0-9_.:-]{0,64}$", v.name))
    ])
    error_message = "Allowed characters `name`: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for v in values(var.cluster_controller) : can(regex("^[a-zA-Z0-9:][a-zA-Z0-9.:-]{0,254}$", v.hostname_ip))
    ])
    error_message = "Allowed characters `hostname_ip`: `a`-`z`, `A`-`Z`, `0`-`9`, `.`, `:`, `-`. Maximum characters: 254."
  }

  validation {
    condition = alltrue([
      for v in values(var.cluster_controller) : v.credentials == null || can(regex("^[a-zA-Z0-9_.:-]{0,512}$", v.cluster_name))
    ])
    error_message = "Allowed characters `credentials`: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 512."
  }

  validation {
    condition = alltrue([
      for v in values(var.cluster_controller) : v.credentials == null || can(regex("^[a-zA-Z0-9_.:-]{0,64}$", v.credentials))
    ])
    error_message = "Allowed characters `credentials`: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for v in values(var.cluster_controller) : v.port >= 0 && v.port <= 65535
    ])
    error_message = "Allowed values for `port`: 0-65535."
  }
}