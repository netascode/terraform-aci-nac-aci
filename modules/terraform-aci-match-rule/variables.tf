variable "tenant" {
  description = "Match rule tenant."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.tenant))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "name" {
  description = "Match rule name."
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

variable "regex_community_terms" {
  description = "List of regex community terms. Default value `type`: `regular`. Allowed values `type`: `regular`, `extended`."
  type = list(object({
    name        = string
    regex       = string
    type        = optional(string, "regular")
    description = optional(string, "")
  }))
  default = []

  validation {
    condition = alltrue([
      for r in var.regex_community_terms : can(regex("^[a-zA-Z0-9_.:-]{0,64}$", r.name))
    ])
    error_message = "`name`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for r in var.regex_community_terms : can(regex("^.{0,64}$", r.regex))
    ])
    error_message = "`regex`: Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for r in var.regex_community_terms : r.type == null || try(contains(["regular", "extended"], r.type), false)
    ])
    error_message = "`type`: Allowed values are `regular` or `extended`."
  }

  validation {
    condition = alltrue([
      for r in var.regex_community_terms : can(regex("^[a-zA-Z0-9\\\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", r.description))
    ])
    error_message = "`description`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, }`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }
}

variable "community_terms" {
  description = "List of community terms. Default value `scope`: `transitive`. Allowed values `scope`: `transitive`, `non-transitive`."
  type = list(object({
    name        = string
    description = optional(string, "")
    factors = optional(list(object({
      community   = string
      description = optional(string, "")
      scope       = optional(string, "transitive")
    })), [])
  }))
  default = []

  validation {
    condition = alltrue([
      for c in var.community_terms : can(regex("^[a-zA-Z0-9_.:-]{0,64}$", c.name))
    ])
    error_message = "`name`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for c in var.community_terms : can(regex("^[a-zA-Z0-9\\\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", c.description))
    ])
    error_message = "`description`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, }`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }

  validation {
    condition = alltrue(flatten([
      for c in var.community_terms : [for f in coalesce(c.factors, []) : contains(["transitive", "non-transitive"], f.scope)]
    ]))
    error_message = "`scope`: Allowed values are `transitive` or `non-transitive`."
  }
}

variable "prefixes" {
  description = "List of prefixes. Default value `aggregate`: false. Allowed values `from_length`: 0-128. Allowed values `to_length`: 0-128."
  type = list(object({
    ip          = string
    description = optional(string, "")
    aggregate   = optional(bool, false)
    from_length = optional(number, 0)
    to_length   = optional(number, 0)
  }))
  default = []

  validation {
    condition = alltrue([
      for p in var.prefixes : p.description == null || can(regex("^[a-zA-Z0-9\\\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", p.description))
    ])
    error_message = "`description`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, }`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }

  validation {
    condition = alltrue([
      for p in var.prefixes : p.from_length == null || try(p.from_length >= 0 && p.from_length <= 128, false)
    ])
    error_message = "`from_length`: Minimum value: 0. Maximum value: 128."
  }

  validation {
    condition = alltrue([
      for p in var.prefixes : p.to_length == null || try(p.to_length >= 0 && p.to_length <= 128, false)
    ])
    error_message = "`to_length`: Minimum value: 0. Maximum value: 128."
  }
}
