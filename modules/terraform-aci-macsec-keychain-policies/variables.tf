variable "name" {
  description = "MACsec Key Policy Name"
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.name))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "description" {
  description = "MACsec Policy description"
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", var.description))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, }`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }
}

variable "key_policies" {
  description = "Key Polices for Key Chain"
  type = list(object({
    name           = string
    key_name       = string
    pre_shared_key = string
    description    = optional(string, "")
    start_time     = optional(string, "now")
    end_time       = optional(string, "infinite")
  }))
  default = []

  validation {
    condition = alltrue([
      for kp in var.key_policies : can(regex("^[a-zA-Z0-9_.:-]{0,64}$", kp.name))
    ])
    error_message = "`name`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for kp in var.key_policies : can(regex("^[a-fA-F0-9]{0,64}$", kp.key_name))
    ])
    error_message = "`keyName`: Allowed characters: `a`-`f`, `A`-`F`, `0`-`9`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for kp in var.key_policies : can(regex("^[a-fA-F0-9]{0,64}$", kp.pre_shared_key))
    ])
    error_message = "`keyName`: Allowed characters: `a`-`f`, `A`-`F`, `0`-`9`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for kp in var.key_policies : kp.description == null || can(regex("^[a-zA-Z0-9\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", kp.description))
    ])
    error_message = "`description`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, }`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }
}
