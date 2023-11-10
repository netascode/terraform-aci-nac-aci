variable "name" {
  description = "VSPAN session name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.name))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "description" {
  description = "VSPAN session description."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", var.description))
    error_message = "Allowed values are: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, }`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }
}

variable "admin_state" {
  description = "VSPAN session administrative state."
  type        = bool
  default     = true
}

variable "destination_name" {
  description = "VSPAN session destination group name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", var.destination_name))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, }`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }
}

variable "destination_description" {
  description = "VSPAN session destination group description."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", var.destination_description))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, }`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }
}

variable "sources" {
  description = "List of VSPAN session sources. Allowed values `direction`: `in`, `out`, `both`."
  type = list(object({
    description         = optional(string, "")
    name                = string
    direction           = optional(string, "both")
    tenant              = optional(string)
    application_profile = optional(string)
    endpoint_group      = optional(string)
    endpoint            = optional(string)
    access_paths = optional(list(object({
      node_id  = number
      node2_id = optional(number)
      fex_id   = optional(number)
      fex2_id  = optional(number)
      pod_id   = optional(number, 1)
      port     = optional(number)
      sub_port = optional(number)
      module   = optional(number, 1)
      channel  = optional(string)
    })), [])
  }))
  default = []


  validation {
    condition = alltrue([
      for s in var.sources : can(regex("^[a-zA-Z0-9_.-]{0,64}$", s.name))
    ])
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for s in var.sources : can(regex("^[a-zA-Z0-9\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", s.description))
    ])
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, }`, `~`, `?`, `&`, `+`. Maximum characters: 128."
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
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for s in var.sources : s.application_profile == null || can(regex("^[a-zA-Z0-9_.-]{0,64}$", s.application_profile))
    ])
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for s in var.sources : s.endpoint_group == null || can(regex("^[a-zA-Z0-9_.-]{0,64}$", s.endpoint_group))
    ])
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for s in var.sources : s.endpoint == null || can(regex("^[a-zA-Z0-9_.:-]{0,64}$", s.endpoint))
    ])
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`, `:`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for s in var.sources : alltrue([
        for path in s.access_paths : path.node_id == null || try(path.node_id >= 1 && path.node_id <= 4000, false)
      ])
    ])
    error_message = "Source Access Path `node_id`: Minimum value: `1`. Maximum value: `400`."
  }

  validation {
    condition = alltrue([
      for s in var.sources : alltrue([
        for path in s.access_paths : path.node2_id == null || try(path.node2_id >= 1 && path.node2_id <= 400, false)
      ])
    ])
    error_message = "Source Access Path `node2_id`: Minimum value: `1`. Maximum value: `400`."
  }

  validation {
    condition = alltrue([
      for s in var.sources : alltrue([
        for path in s.access_paths : path.fex_id == null || try(path.fex_id >= 101 && path.fex_id <= 199, false)
      ])
    ])
    error_message = "Source Access Path `fex_id`: Minimum value: `101`. Maximum value: `199`."
  }

  validation {
    condition = alltrue([
      for s in var.sources : alltrue([
        for path in s.access_paths : path.fex2_id == null || try(path.fex2_id >= 101 && path.fex2_id <= 199, false)
      ])
    ])
    error_message = "Source Access Path `fex2_id`: Minimum value: `101`. Maximum value: `199`."
  }

  validation {
    condition = alltrue([
      for s in var.sources : alltrue([
        for path in s.access_paths : (path.pod_id >= 1 && path.pod_id <= 255)
      ])
    ])
    error_message = "Source Access Path `pod_id`: Minimum value: `1`. Maximum value: `255`."
  }

  validation {
    condition = alltrue([
      for s in var.sources : alltrue([
        for path in s.access_paths : path.port == null || try(path.port >= 1 && path.port <= 127, false)
      ])
    ])
    error_message = "Source Access Path `port`: Minimum value: `1`. Maximum value: `127`."
  }

  validation {
    condition = alltrue([
      for s in var.sources : alltrue([
        for path in s.access_paths : path.sub_port == null || try(path.sub_port >= 1 && path.sub_port <= 16, false)
      ])
    ])
    error_message = "Source Access Path `sub_port`: Minimum value: `1`. Maximum value: `16`."
  }

  validation {
    condition = alltrue([
      for s in var.sources : alltrue([
        for path in s.access_paths : (path.module >= 1 && path.module <= 9)
      ])
    ])
    error_message = "Source Access Path `module`: Minimum value: `1`. Maximum value: `9`."
  }

}
