variable "name" {
  description = "OOB Contract name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.name))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "alias" {
  description = "Alias."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.alias))
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

variable "scope" {
  description = "Scope. Choices: `application-profile`, `tenant`, `context`, `global`."
  type        = string
  default     = "context"

  validation {
    condition     = contains(["application-profile", "tenant", "context", "global"], var.scope)
    error_message = "Allowed values: `application-profile`, `tenant`, `context` or `global`."
  }
}

variable "subjects" {
  description = "List of subjects."
  type = list(object({
    name        = string
    alias       = optional(string, "")
    description = optional(string, "")
    filters = list(object({
      filter = string
    }))
  }))
  default = []


  validation {
    condition = alltrue([
      for s in var.subjects : can(regex("^[a-zA-Z0-9_.:-]{0,64}$", s.name))
    ])
    error_message = "`name`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for s in var.subjects : s.alias == null || can(regex("^[a-zA-Z0-9_.:-]{0,64}$", s.alias))
    ])
    error_message = "`alias`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for s in var.subjects : s.description == null || can(regex("^[a-zA-Z0-9\\\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", s.description))
    ])
    error_message = "`description`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, }`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }

  validation {
    condition = alltrue(flatten([
      for s in var.subjects : [for f in coalesce(s.filters, []) : can(regex("^[a-zA-Z0-9_.:-]{0,64}$", f.filter))]
    ]))
    error_message = "`filter`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

