variable "name" {
  description = "Netflow VMM Exporter name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.name))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "description" {
  description = "Netflow VMM Exporter description."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", var.description))
    error_message = "Allowed values are: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, }`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }
}

variable "destination_ip" {
  description = "Netflow VMM Exporter destination address."
  type        = string
}


variable "destination_port" {
  description = "Netflow VMM Exporter destination port."
  type        = string

  validation {
    condition     = var.destination_port >= 0 && var.destination_port <= 65535
    error_message = "Minimum value: 0, Maximum value: 65535."
  }
}

variable "source_ip" {
  description = "Netflow VMM Exporter source address."
  type        = string
  default     = "0.0.0.0"
}