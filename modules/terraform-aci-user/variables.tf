variable "username" {
  description = "Username."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{1,31}$", var.username))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 31."
  }
}

variable "password" {
  description = "Password."
  type        = string
  sensitive   = true

  validation {
    condition     = can(regex("^.{1,256}$", var.password))
    error_message = "Maximum characters: 256."
  }
}

variable "status" {
  description = "Status. Choices: `active`, `inactive`, `blocked`."
  type        = string
  default     = "active"

  validation {
    condition     = contains(["active", "inactive", "blocked"], var.status)
    error_message = "Allowed values are `active`, `inactive` or `blocked`."
  }
}

variable "certificate_name" {
  description = "Certificate name."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^.{0,128}$", var.certificate_name))
    error_message = "Maximum characters: 128."
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

variable "email" {
  description = "Email"
  type        = string
  default     = ""

  validation {
    condition     = var.email == "" || can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+$", var.email))
    error_message = "Invalid email."
  }
}

variable "expires" {
  description = "Expires."
  type        = bool
  default     = false
}

variable "expire_date" {
  description = "Expire date. Allowed values are `never` or timestamp like `2021-01-20T10:00:00.000+00:00`."
  type        = string
  default     = "never"
}

variable "first_name" {
  description = "First name."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^.{0,32}$", var.first_name))
    error_message = "Maximum characters: 32."
  }
}

variable "last_name" {
  description = "Last name."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^.{0,32}$", var.last_name))
    error_message = "Maximum characters: 32."
  }
}

variable "phone" {
  description = "Phone."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^.{0,16}$", var.phone))
    error_message = "Maximum characters: 16."
  }
}

variable "domains" {
  description = "List of domains. Choices `privilege_type`: `write`, `read`. Default value `privilege_type`: `read`."
  type = list(object({
    name = string
    roles = optional(list(object({
      name           = string
      privilege_type = optional(string, "read")
    })), [])
  }))
  default = []

  validation {
    condition = alltrue([
      for d in var.domains : can(regex("^[a-zA-Z0-9_.:-]{1,64}$", d.name))
    ])
    error_message = "Allowed characters `name`: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue(flatten([
      for d in var.domains : [for r in coalesce(d.roles, []) : can(regex("^[a-zA-Z0-9_.-]{0,64}$", r.name))]
    ]))
    error_message = "`roles.name`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue(flatten([
      for d in var.domains : [for r in coalesce(d.roles, []) : r.privilege_type == null || try(contains(["write", "read"], r.privilege_type), false)]
    ]))
    error_message = "`privilege_type`: Allowed values are `write` or `read`."
  }
}

variable "certificates" {
  description = "List of certificates."
  type = list(object({
    name = string
    data = string
  }))
  default = []

  validation {
    condition = alltrue([
      for c in var.certificates : can(regex("^[a-zA-Z0-9_.:-]{1,64}$", c.name))
    ])
    error_message = "Allowed characters `name`: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "ssh_keys" {
  description = "List of SSH keys."
  type = list(object({
    name = string
    data = string
  }))
  default = []

  validation {
    condition = alltrue([
      for s in var.ssh_keys : can(regex("^[a-zA-Z0-9_.:-]{1,64}$", s.name))
    ])
    error_message = "Allowed characters `name`: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for s in var.ssh_keys : can(regex("^[a-zA-Z0-9=\n\r/+ _.@-]{1,16384}$", s.data))
    ])
    error_message = "Allowed characters `data`: `a`-`z`, `A`-`Z`, `0`-`9`, `=`, `\n`, `\r`, `+`, ` `, `_`, `.`, `@`, `-`. Maximum characters: 16384."
  }
}
