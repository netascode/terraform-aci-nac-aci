variable "name" {
  description = "SPAN source group name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.name))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "description" {
  description = "SPAN source group description."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", var.description))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, }`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }
}

variable "admin_state" {
  description = "SPAN source group administrative state."
  type        = bool
  default     = true
}

variable "sources" {
  description = "List of SPAN sources. Choices `direction`: `in`, `both`, `out`. Default value `direction`: `both`. Default value `span_drop`: `false`. Allowed values `node_id`: `1` - `4000`. Allowed values `pod_id`: `1` - `255`. Default value `pod_id`: `1`. Allowed values `port`: `1` - `127`. Allowed values `module`: `1` - `9`. Default value `module`: `1`."
  type = list(object({
    description   = optional(string, "")
    name          = string
    direction     = optional(string, "both")
    span_drop     = optional(bool, false)
    tenant        = optional(string)
    bridge_domain = optional(string)
    vrf           = optional(string)
    fabric_paths = optional(list(object({
      node_id = number
      pod_id  = optional(number, 1)
      port    = number
      module  = optional(number, 1)
    })), [])
  }))
  default = []

  validation {
    condition = alltrue([
      for s in var.sources : s.name == null || can(regex("^[a-zA-Z0-9_.-]{0,64}$", s.name))
    ])
    error_message = "Source `name`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for s in var.sources : can(regex("^[a-zA-Z0-9\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", s.description))
    ])
    error_message = "Source `description`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, }`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }

  validation {
    condition = alltrue([
      for s in var.sources : contains(["in", "both", "out"], s.direction)
    ])
    error_message = "Source `direction`: Valid values are `in`, `both` or `out`."
  }

  validation {
    condition = alltrue([
      for s in var.sources : s.tenant == null || can(regex("^[a-zA-Z0-9_.-]{0,64}$", s.tenant))
    ])
    error_message = "Source `tenant`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for s in var.sources : s.vrf == null || can(regex("^[a-zA-Z0-9_.-]{0,64}$", s.vrf))
    ])
    error_message = "Source `vrf`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for s in var.sources : s.bridge_domain == null || can(regex("^[a-zA-Z0-9_.-]{0,64}$", s.bridge_domain))
    ])
    error_message = "Source `bridge_domain`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for s in var.sources : alltrue([
        for path in s.fabric_paths : path.node_id == null || try(path.node_id >= 1 && path.node_id <= 4000, false)
      ])
    ])
    error_message = "Source Fabric Path `node_id`: Minimum value: `1`. Maximum value: `400`."
  }

  validation {
    condition = alltrue([
      for s in var.sources : alltrue([
        for path in s.fabric_paths : (path.pod_id >= 1 && path.pod_id <= 255)
      ])
    ])
    error_message = "Source Fabric Path `pod_id`: Minimum value: `1`. Maximum value: `255`."
  }

  validation {
    condition = alltrue([
      for s in var.sources : alltrue([
        for path in s.fabric_paths : path.port == null || try(path.port >= 1 && path.port <= 127, false)
      ])
    ])
    error_message = "Source Fabric Path `port`: Minimum value: `1`. Maximum value: `127`."
  }

  validation {
    condition = alltrue([
      for s in var.sources : alltrue([
        for path in s.fabric_paths : (path.module >= 1 && path.module <= 9)
      ])
    ])
    error_message = "Source Fabric Path `module`: Minimum value: `1`. Maximum value: `9`."
  }
}

variable "destination_name" {
  description = "SPAN source destination group name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.destination_name))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "destination_description" {
  description = "SPAN source destination group description."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", var.destination_description))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, }`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }
}
