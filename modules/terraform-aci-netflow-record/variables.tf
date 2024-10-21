variable "name" {
  description = "Netflow Record name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.name))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "description" {
  description = "Netflow Record description."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9\\\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", var.description))
    error_message = "Allowed values are: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, }`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }
}

variable "match_parameters" {
  description = "Netflow Record match parameters. Allowed values: `dst-ip`, `dst-ipv4`, `dst-ipv6`, `dst-mac`, `dst-port`, `ethertype`, `proto`, `src-ip`, `src-ipv4`, `src-ipv6`, `src-mac`, `src-port`, `tos`, `vlan`, `unspecified`."
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for p in var.match_parameters : contains(["dst-ip", "dst-ipv4", "dst-ipv6", "dst-mac", "dst-port", "ethertype", "proto", "src-ip", "src-ipv4", "src-ipv6", "src-mac", "src-port", "tos", "vlan", "unspecified"], p)
    ])
    error_message = "`match_parameters`: Allowed values: `dst-ip`, `dst-ipv4`, `dst-ipv6`, `dst-mac`, `dst-port`, `ethertype`, `proto`, `src-ip`, `src-ipv4`, `src-ipv6`, `src-mac`, `src-port`, `tos`, `vlan`, `unspecified`."
  }
}
