variable "mode" {
  description = "Mode. Choices: `explicit`, `consecutive`, `reciprocal`."
  type        = string
  default     = "explicit"

  validation {
    condition     = contains(["explicit", "consecutive", "reciprocal"], var.mode)
    error_message = "Allowed values are `explicit`, `consecutive` or `reciprocal`."
  }
}

variable "groups" {
  description = "List of groups. Allowed values `id`: 1-1000. Allowed values `switch_1`: 1-16000. Allowed values `switch_2`: 1-16000."
  type = list(object({
    name     = string
    id       = number
    policy   = optional(string)
    switch_1 = number
    switch_2 = number
  }))
  default = []

  validation {
    condition = alltrue([
      for g in var.groups : can(regex("^[a-zA-Z0-9_.:-]{0,64}$", g.name))
    ])
    error_message = "Allowed characters `name`: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for g in var.groups : g.id >= 1 && g.id <= 1000
    ])
    error_message = "Allowed values `id`: 1-1000."
  }

  validation {
    condition = alltrue([
      for g in var.groups : can(regex("^[a-zA-Z0-9_.:-]{0,64}$", g.policy))
    ])
    error_message = "Allowed characters `policy`: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for g in var.groups : g.switch_1 >= 1 && g.switch_1 <= 16000
    ])
    error_message = "Allowed values `switch_1`: 1-16000."
  }

  validation {
    condition = alltrue([
      for g in var.groups : g.switch_2 >= 1 && g.switch_2 <= 16000
    ])
    error_message = "Allowed values `switch_2`: 1-16000."
  }
}
