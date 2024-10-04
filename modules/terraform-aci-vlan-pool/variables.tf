variable "name" {
  description = "Vlan pool name."
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

variable "allocation" {
  description = "Allocation mode. Choices: `static`, `dynamic`."
  type        = string
  default     = "static"

  validation {
    condition     = contains(["static", "dynamic"], var.allocation)
    error_message = "Allowed values are `static` and `dynamic`."
  }
}

variable "ranges" {
  description = "List of ranges. Allowed values `from`: 1-4096. Allowed values `to`: 1-4096. Default value `to`: <from>. Choices `allocation`: `static`, `dynamic`, `inherit`. Default value `allocation`: `inherit`. Choices `role`: `internal`, `external`. Default value `role`: `external`."
  type = list(object({
    description = optional(string, "")
    from        = number
    to          = optional(number)
    allocation  = optional(string, "inherit")
    role        = optional(string, "external")
  }))
  default = []

  validation {
    condition = alltrue([
      for r in var.ranges : can(regex("^[a-zA-Z0-9\\\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", r.description))
    ])
    error_message = "Allowed characters `description`: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, }`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }

  validation {
    condition = alltrue([
      for r in var.ranges : r.from >= 1 && r.from <= 4096
    ])
    error_message = "Allowed values `from`: 1-4096."
  }

  validation {
    condition = alltrue([
      for r in var.ranges : r.to == null || try(r.to >= 1 && r.to <= 4096, false)
    ])
    error_message = "Allowed values `to`: 1-4096."
  }

  validation {
    condition = alltrue([
      for r in var.ranges : r.allocation == null || try(contains(["static", "dynamic", "inherit"], r.allocation), false)
    ])
    error_message = "`allocation`: Allowed values are `static`, `dynamic` or `inherit`."
  }

  validation {
    condition = alltrue([
      for r in var.ranges : r.role == null || try(contains(["external", "internal"], r.role), false)
    ])
    error_message = "`role`: Allowed values are `external` or `internal`."
  }
}
