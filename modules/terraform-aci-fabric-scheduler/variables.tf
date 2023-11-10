variable "name" {
  description = "Fabric scheduler name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.name))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
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

variable "recurring_windows" {
  description = "List of recurring windows. Choices `day`: `every-day`, `odd-day`, `even-day`, `Monday`, `Tuesday`, `Wednesday`, `Thursday`, `Friday`, `Saturday`, `Sunday`. Allowed values `hour`: 0-23. Allowed values `minute`: 0-59."
  type = list(object({
    name   = string
    day    = optional(string, "every-day")
    hour   = optional(number, 0)
    minute = optional(number, 0)
  }))
  default = []

  validation {
    condition = alltrue([
      for w in var.recurring_windows : can(regex("^[a-zA-Z0-9_.-]{0,64}$", w.name))
    ])
    error_message = "`name`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for w in var.recurring_windows : w.day == null || try(contains(["every-day", "odd-day", "even-day", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"], w.day), false)
    ])
    error_message = "`day`: Allowed values are `every-day`, `odd-day`, `even-day`, `Monday`, `Tuesday`, `Wednesday`, `Thursday`, `Friday`, `Saturday` or `Sunday`."
  }

  validation {
    condition = alltrue([
      for w in var.recurring_windows : w.hour == null || (w.hour >= 0 && w.hour <= 23)
    ])
    error_message = "`hour`: Minimum value: 0. Maximum value: 23."
  }

  validation {
    condition = alltrue([
      for w in var.recurring_windows : w.minute == null || (w.minute >= 0 && w.minute <= 59)
    ])
    error_message = "`minute`: Minimum value: 0. Maximum value: 59."
  }
}
