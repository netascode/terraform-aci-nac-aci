variable "tenant" {
  description = "Tenant name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.tenant))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "name" {
  description = "Track List name."
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

variable "type" {
  description = "Type of Track List. Allowed values: `percentage`, `weight`."
  type        = string
  default     = "percentage"

  validation {
    condition     = contains(["percentage", "weight"], var.type)
    error_message = "Allowed values: `percentage`, `weight`."
  }
}

variable "percentage_down" {
  description = "Down Threshold percentage. Minimum value: 0. Maximum value: 100."
  type        = number
  default     = 0

  validation {
    condition     = var.percentage_down >= 0 && var.percentage_down <= 100
    error_message = "Minimum value: 0. Maximum value: 100."
  }
}

variable "percentage_up" {
  description = "Up Threshold percentage. Minimum value: 0. Maximum value: 100."
  type        = number
  default     = 0

  validation {
    condition     = var.percentage_up >= 0 && var.percentage_up <= 100
    error_message = "Minimum value: 0. Maximum value: 100."
  }
}

variable "weight_down" {
  description = "Down Threshold weight. Minimum value: 0. Maximum value: 255."
  type        = number
  default     = 0

  validation {
    condition     = var.weight_down >= 0 && var.weight_down <= 255
    error_message = "Minimum value: 0. Maximum value: 255."
  }
}

variable "weight_up" {
  description = "Up Threshold weight. Minimum value: 0. Maximum value: 255."
  type        = number
  default     = 0

  validation {
    condition     = var.weight_up >= 0 && var.weight_up <= 255
    error_message = "Minimum value: 0. Maximum value: 255."
  }
}

variable "track_members" {
  description = "Track List members."
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for c in var.track_members : can(regex("^[a-zA-Z0-9_.l-]{0,64}$", c))
    ])
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}