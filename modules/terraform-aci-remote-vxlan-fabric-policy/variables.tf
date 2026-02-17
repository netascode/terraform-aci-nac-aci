variable "name" {
  description = "Remote Vxlan Fabric name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.name))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "remote_evpn_peers" {
  description = "List of Remote EVPN peers."
  type = list(object({
    ip                    = string
    description           = optional(string)
    remote_as             = string
    admin_state           = optional(bool, true)
    allow_self_as         = optional(bool, false)
    disable_peer_as_check = optional(bool, false)
    password              = optional(string)
    ttl                   = optional(number)
    peer_prefix_policy    = optional(string)
    as_propagate          = optional(string)
    local_as              = optional(number)
  }))
  default = []


  validation {
    condition = alltrue([
      for b in var.remote_evpn_peers : b.remote_as >= 0 && b.remote_as <= 4294967295
    ])
    error_message = "`remote_as`: Minimum value: `0`. Maximum value: `4294967295`."
  }

  validation {
    condition = alltrue([
      for b in var.remote_evpn_peers : b.description == null || try(can(regex("^[a-zA-Z0-9\\\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", b.description)), false)
    ])
    error_message = "`description`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, }`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }

  validation {
    condition = alltrue([
      for b in var.remote_evpn_peers : try(b.ttl >= 1 && b.ttl <= 255, false)
    ])
    error_message = "`ttl`: Minimum value: `1`. Maximum value: `255`."
  }

  validation {
    condition = alltrue([
      for b in var.remote_evpn_peers : b.local_as == null || try(b.local_as >= 0 && b.local_as <= 4294967295, false)
    ])
    error_message = "`local_as`: Minimum value: `0`. Maximum value: `4294967295`."
  }

  validation {
    condition = alltrue([
      for b in var.remote_evpn_peers : b.as_propagate == null || try(contains(["none", "no-prepend", "replace-as", "dual-as"], b.as_propagate), false)
    ])
    error_message = "`as_propagate`: Allowed value are: `none`, `no-prepend`, `replace-as` or `dual-as`."
  }
}


variable "border_gateway_set" {
  description = "Border Gateway Set policy name"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.border_gateway_set))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}