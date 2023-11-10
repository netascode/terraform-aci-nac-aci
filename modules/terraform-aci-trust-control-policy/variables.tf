variable "tenant" {
  description = "Tenant name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.tenant))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "name" {
  description = "Trust control policy name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.name))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "description" {
  description = "Trust control policy description."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", var.description))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, }`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }
}

variable "dhcp_v4_server" {
  description = "DHCP IPv4 server flag."
  type        = bool
  default     = false
}

variable "dhcp_v6_server" {
  description = "DHCP IPv6 server flag."
  type        = bool
  default     = false
}

variable "ipv6_router" {
  description = "IPv6 router flag."
  type        = bool
  default     = false
}

variable "arp" {
  description = "ARP flag."
  type        = bool
  default     = false
}

variable "nd" {
  description = "IPv6 neighbor discovery flag."
  type        = bool
  default     = false
}

variable "ra" {
  description = "IPv6 router advertisment flag."
  type        = bool
  default     = false
}
