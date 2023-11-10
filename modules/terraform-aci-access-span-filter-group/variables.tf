variable "name" {
  description = "Access SPAN Filter Group name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.name))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "description" {
  description = "Access SPAN Filter Group description."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", var.description))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, }`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }
}

variable "entries" {
  description = "Access SPAN Filter Group entries. Allowed values `ip_protocol`: `unspecified`, `icmp`, `igmp`, `tcp`, `egp`, `igp`, `udp`, `icmpv6`, `eigrp`, `ospfigp`, `pim`, `l2tp` or a number between 0 and 255. Default value `protocol`: `tcp`. Allowed values `destination_from_port`, `destination_to_port`, `destination_from_port`, `source_from_port`: `source_to_port`, `dns`, `ftpData`, `http`, `https`, `pop3`, `rtsp`, `smtp`, `ssh` or a number between 0 and 65535. Default value `source_from_port`, `source_to_port`, `destination_from_port`, `destination_to_port`: `unspecified`."
  type = list(object({
    name                  = string
    description           = optional(string, "")
    destination_ip        = string
    destination_from_port = optional(string, "unspecified")
    destination_to_port   = optional(string)
    ip_protocol           = optional(string, "unspecified")
    source_ip             = string
    source_from_port      = optional(string, "unspecified")
    source_to_port        = optional(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for e in var.entries : can(regex("^[a-zA-Z0-9_.-]{0,64}$", e.name))
    ])
    error_message = "Entries `name`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for e in var.entries : e.description == null || can(regex("^[a-zA-Z0-9\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", e.description))
    ])
    error_message = "Entries `description`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, }`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }

  validation {
    condition = alltrue([
      for e in var.entries : try(contains(["unspecified", "dns", "ftpData", "http", "https", "pop3", "rtsp", "smtp", "ssh"], e.destination_from_port), false) || try(tonumber(e.destination_from_port) >= 0 && tonumber(e.destination_from_port) <= 65535, false)
    ])
    error_message = "Entries `destination_from_port`: Allowed values are `unspecified`, `dns`, `ftpData`, `http`, `https`, `pop3`, `rtsp`, `smtp`, `ssh` or a number between 0 and 65535."
  }

  validation {
    condition = alltrue([
      for e in var.entries : e.destination_to_port == null || try(contains(["unspecified", "dns", "ftpData", "http", "https", "pop3", "rtsp", "smtp", "ssh"], e.destination_to_port), false) || try(tonumber(e.destination_to_port) >= 0 && tonumber(e.destination_to_port) <= 65535, false)
    ])
    error_message = "Entries `destination_to_port`: Allowed values are `unspecified`, `dns`, `ftpData`, `http`, `https`, `pop3`, `rtsp`, `smtp`, `ssh` or a number between 0 and 65535."
  }

  validation {
    condition = alltrue([
      for e in var.entries : try(contains(["unspecified", "icmp", "igmp", "tcp", "egp", "igp", "udp", "icmpv6", "eigrp", "ospfigp", "pim", "l2tp"], e.ip_protocol), false) || try(tonumber(e.ip_protocol) >= 0 && tonumber(e.ip_protocol) <= 255, false)
    ])
    error_message = "Entries `ip_protocol`: Allowed values are `unspecified`, `icmp`, `igmp`, `tcp`, `egp`, `igp`, `udp`, `icmpv6`, `eigrp`, `ospfigp`, `pim`, `l2tp` or a number between 0 and 255."
  }

  validation {
    condition = alltrue([
      for e in var.entries : try(contains(["unspecified", "dns", "ftpData", "http", "https", "pop3", "rtsp", "smtp", "ssh"], e.source_from_port), false) || try(tonumber(e.source_from_port) >= 0 && tonumber(e.source_from_port) <= 65535, false)
    ])
    error_message = "Entries `source_from_port`: Allowed values are `unspecified`, `dns`, `ftpData`, `http`, `https`, `pop3`, `rtsp`, `smtp`, `ssh` or a number between 0 and 65535."
  }

  validation {
    condition = alltrue([
      for e in var.entries : e.source_to_port == null || try(contains(["unspecified", "dns", "ftpData", "http", "https", "pop3", "rtsp", "smtp", "ssh"], e.source_to_port), false) || try(tonumber(e.source_to_port) >= 0 && tonumber(e.source_to_port) <= 65535, false)
    ])
    error_message = "Entries `source_to_port`: Allowed values are `unspecified`, `dns`, `ftpData`, `http`, `https`, `pop3`, `rtsp`, `smtp`, `ssh` or a number between 0 and 65535."
  }
}
