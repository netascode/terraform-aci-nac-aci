variable "tenant" {
  description = "Tenant name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.tenant))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "name" {
  description = "OSPF route summarization policy name."
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
    condition     = can(regex("^[a-zA-Z0-9\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", var.description))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, }`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }
}

variable "cost" {
  description = "Route cost. Allowed values are `unspecified` or a number between 0 and 16777215."
  type        = string
  default     = "unspecified"

  validation {
    condition = var.cost == "unspecified" || (
      can(tonumber(var.cost)) &&
      tonumber(var.cost) >= 0 &&
      tonumber(var.cost) <= 16777215
    )
    error_message = "Allowed values are `unspecified` or a number between 0 and 16777215."
  }
}

variable "inter_area_enabled" {
  description = "Inter-area enabled."
  type        = bool
  default     = false
}

variable "tag" {
  description = "Route tag. Minimum value: 0. Maximum value: 4294967295."
  type        = number
  default     = 0

  validation {
    condition     = var.tag >= 0 && var.tag <= 4294967295
    error_message = "Minimum value: 0. Maximum value: 4294967295."
  }
}

variable "name_alias" {
  description = "Name alias."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.name_alias))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}