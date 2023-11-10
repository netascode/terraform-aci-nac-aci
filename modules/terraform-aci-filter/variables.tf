variable "tenant" {
  description = "Tenant name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.tenant))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "name" {
  description = "Filter name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.name))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "alias" {
  description = "Filter alias."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.alias))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "description" {
  description = "Filter description."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", var.description))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, }`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }
}

variable "entries" {
  description = "List of filter entries. Choices `ethertype`: `unspecified`, `ipv4`, `trill`, `arp`, `ipv6`, `mpls_ucast`, `mac_security`, `fcoe`, `ip`. Default value `ethertype`: `ip`. Allowed values `protocol`: `unspecified`, `icmp`, `igmp`, `tcp`, `egp`, `igp`, `udp`, `icmpv6`, `eigrp`, `ospfigp`, `pim`, `l2tp` or a number between 0 and 255. Default value `protocol`: `tcp`. Allowed values `source_from_port`, `source_to_port`, `destination_from_port`, `destination_to_port`: `unspecified`, `dns`, `ftpData`, `http`, `https`, `pop3`, `rtsp`, `smtp`, `ssh` or a number between 0 and 65535. Default value `source_from_port`, `source_to_port`, `destination_from_port`, `destination_to_port`: `unspecified`. Default value `stateful`: false."
  type = list(object({
    name                  = string
    alias                 = optional(string, "")
    description           = optional(string, "")
    ethertype             = optional(string, "ip")
    protocol              = optional(string, "tcp")
    source_from_port      = optional(string, "unspecified")
    source_to_port        = optional(string, "unspecified")
    destination_from_port = optional(string, "unspecified")
    destination_to_port   = optional(string, "unspecified")
    stateful              = optional(bool, false)
  }))
  default = []

  validation {
    condition = alltrue([
      for e in var.entries : can(regex("^[a-zA-Z0-9_.-]{0,64}$", e.name))
    ])
    error_message = "`name`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for e in var.entries : e.alias == null || can(regex("^[a-zA-Z0-9_.-]{0,64}$", e.alias))
    ])
    error_message = "`alias`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for e in var.entries : e.description == null || can(regex("^[a-zA-Z0-9\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", e.description))
    ])
    error_message = "`description`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, }`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }

  validation {
    condition = alltrue([
      for e in var.entries : e.ethertype == null || try(contains(["unspecified", "ipv4", "trill", "arp", "ipv6", "mpls_ucast", "mac_security", "fcoe", "ip"], e.ethertype), false)
    ])
    error_message = "`ethertype`: Allowed values are `unspecified`, `ipv4`, `trill`, `arp`, `ipv6`, `mpls_ucast`, `mac_security`, `fcoe` or `ip`."
  }

  validation {
    condition = alltrue([
      for e in var.entries : e.protocol == null || try(contains(["unspecified", "icmp", "igmp", "tcp", "egp", "igp", "udp", "icmpv6", "eigrp", "ospfigp", "pim", "l2tp"], e.protocol), false) || try(tonumber(e.protocol) >= 0 && tonumber(e.protocol) <= 255, false)
    ])
    error_message = "`protocol`: Allowed values are `unspecified`, `icmp`, `igmp`, `tcp`, `egp`, `igp`, `udp`, `icmpv6`, `eigrp`, `ospfigp`, `pim`, `l2tp` or a number between 0 and 255."
  }

  validation {
    condition = alltrue([
      for e in var.entries : e.source_from_port == null || try(contains(["unspecified", "dns", "ftpData", "http", "https", "pop3", "rtsp", "smtp", "ssh"], e.source_from_port), false) || try(tonumber(e.source_from_port) >= 0 && tonumber(e.source_from_port) <= 65535, false)
    ])
    error_message = "`source_from_port`: Allowed values are `unspecified`, `dns`, `ftpData`, `http`, `https`, `pop3`, `rtsp`, `smtp`, `ssh` or a number between 0 and 65535."
  }

  validation {
    condition = alltrue([
      for e in var.entries : e.source_to_port == null || try(contains(["unspecified", "dns", "ftpData", "http", "https", "pop3", "rtsp", "smtp", "ssh"], e.source_to_port), false) || try(tonumber(e.source_to_port) >= 0 && tonumber(e.source_to_port) <= 65535, false)
    ])
    error_message = "`source_to_port`: Allowed values are `unspecified`, `dns`, `ftpData`, `http`, `https`, `pop3`, `rtsp`, `smtp`, `ssh` or a number between 0 and 65535."
  }

  validation {
    condition = alltrue([
      for e in var.entries : e.destination_from_port == null || try(contains(["unspecified", "dns", "ftpData", "http", "https", "pop3", "rtsp", "smtp", "ssh"], e.destination_from_port), false) || try(tonumber(e.destination_from_port) >= 0 && tonumber(e.destination_from_port) <= 65535, false)
    ])
    error_message = "`destination_from_port`: Allowed values are `unspecified`, `dns`, `ftpData`, `http`, `https`, `pop3`, `rtsp`, `smtp`, `ssh` or a number between 0 and 65535."
  }

  validation {
    condition = alltrue([
      for e in var.entries : e.destination_to_port == null || try(contains(["unspecified", "dns", "ftpData", "http", "https", "pop3", "rtsp", "smtp", "ssh"], e.destination_to_port), false) || try(tonumber(e.destination_to_port) >= 0 && tonumber(e.destination_to_port) <= 65535, false)
    ])
    error_message = "`destination_to_port`: Allowed values are `unspecified`, `dns`, `ftpData`, `http`, `https`, `pop3`, `rtsp`, `smtp`, `ssh` or a number between 0 and 65535."
  }
}
