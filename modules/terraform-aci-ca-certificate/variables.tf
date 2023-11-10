variable "name" {
  description = "CA certificate name."
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

variable "certificate_chain" {
  description = "CA certificate chain."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9=\n\r/+ _.@-]*$", var.certificate_chain))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `\n`, `\r`, `/`, `+`, ` `, `_`, `.`, `@`, `-`. Maximum characters: 16384."
  }
}
