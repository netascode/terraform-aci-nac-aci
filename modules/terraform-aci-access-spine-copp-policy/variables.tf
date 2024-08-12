variable "name" {
  description = "Attachable access entity profile name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.name))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "description" {
  description = "Attachable access entity profile description"
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", var.description))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, }`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }
}

variable "type" {
  description = "Profile type. Allowed values: `default`, `custom`, `strict`, `moderate`, `lenient`."
  type        = string
  default     = "default"

  validation {
    condition     = contains(["default", "custom", "strict", "moderate", "lenient"], var.type)
    error_message = "Allowed values: `default`, `custom`, `strict`, `moderate`, `lenient`."
  }
}

variable "custom_values" {
  description = "Custom CoPP values"
  type        = any
  # default = null

  validation {
    condition     = try(var.custom_values.arp_rate == "default" || try(tonumber(var.custom_values.arp_rate) >= 10 && tonumber(var.custom_values.arp_rate) <= 1360, false), var.custom_values.arp_rate)
    error_message = "Allowed Values: `default` or a number between 10 and 1360."
  }

  validation {
    condition     = try(var.custom_values.arp_burst == "default" || try(tonumber(var.custom_values.arp_burst) >= 10 && tonumber(var.custom_values.arp_burst) <= 340, false), var.custom_values.arp_burst)
    error_message = "Allowed Values: `default` or a number between 10 and 340."
  }

  validation {
    condition     = try(var.custom_values.bgp_rate == "default" || try(tonumber(var.custom_values.bgp_rate) >= 10 && tonumber(var.custom_values.bgp_rate) <= 5000, false), var.custom_values.bgp_rate)
    error_message = "Allowed Values: `default` or a number between 10 and 5000."
  }

  validation {
    condition     = try(var.custom_values.bgp_burst == "default" || try(tonumber(var.custom_values.bgp_burst) >= 10 && tonumber(var.custom_values.bgp_burst) <= 5000, false), var.custom_values.bgp_burst)
    error_message = "Allowed Values: `default` or a number between 10 and 5000."
  }

  validation {
    condition     = try(var.custom_values.cdp_rate == "default" || try(tonumber(var.custom_values.cdp_rate) >= 10 && tonumber(var.custom_values.cdp_rate) <= 1000, false), var.custom_values.cdp_rate)
    error_message = "Allowed Values: `default` or a number between 10 and 1000."
  }

  validation {
    condition     = try(var.custom_values.cdp_burst == "default" || try(tonumber(var.custom_values.cdp_burst) >= 10 && tonumber(var.custom_values.cdp_burst) <= 1000, false), var.custom_values.cdp_burst)
    error_message = "Allowed Values: `default` or a number between 10 and 1000."
  }

  validation {
    condition     = try(var.custom_values.coop_rate == "default" || try(tonumber(var.custom_values.coop_rate) >= 1000 && tonumber(var.custom_values.coop_rate) <= 5000, false), var.custom_values.coop_rate)
    error_message = "Allowed Values: `default` or a number between 1000 and 5000."
  }

  validation {
    condition     = try(var.custom_values.coop_burst == "default" || try(tonumber(var.custom_values.coop_burst) >= 1000 && tonumber(var.custom_values.coop_burst) <= 5000, false), var.custom_values.coop_burst)
    error_message = "Allowed Values: `default` or a number between 1000 and 5000."
  }

  validation {
    condition     = try(var.custom_values.dhcp_rate == "default" || try(tonumber(var.custom_values.dhcp_rate) >= 100 && tonumber(var.custom_values.dhcp_rate) <= 1360, false), var.custom_values.dhcp_rate)
    error_message = "Allowed Values: `default` or a number between 100 and 1360."
  }

  validation {
    condition     = try(var.custom_values.dhcp_burst == "default" || try(tonumber(var.custom_values.dhcp_burst) >= 100 && tonumber(var.custom_values.dhcp_burst) <= 340, false), var.custom_values.dhcp_burst)
    error_message = "Allowed Values: `default` or a number between 100 and 340."
  }

  validation {
    condition     = try(var.custom_values.glean_rate == "default" || try(tonumber(var.custom_values.glean_rate) >= 10 && tonumber(var.custom_values.glean_rate) <= 500, false), var.custom_values.glean_rate)
    error_message = "Allowed Values: `default` or a number between 10 and 500."
  }

  validation {
    condition     = try(var.custom_values.glean_burst == "default" || try(tonumber(var.custom_values.glean_burst) >= 10 && tonumber(var.custom_values.glean_burst) <= 500, false), var.custom_values.glean_burst)
    error_message = "Allowed Values: `default` or a number between 10 and 500."
  }

  validation {
    condition     = try(var.custom_values.ifc_rate == "default" || try(tonumber(var.custom_values.ifc_rate) <= 5000 && tonumber(var.custom_values.ifc_rate) <= 10000, false), var.custom_values.ifc_rate)
    error_message = "Allowed Values: `default` or a number between 5000 and 10000."
  }

  validation {
    condition     = try(var.custom_values.ifc_burst == "default" || try(tonumber(var.custom_values.ifc_burst) <= 5000 && tonumber(var.custom_values.ifc_burst) <= 10000, false), var.custom_values.ifc_burst)
    error_message = "Allowed Values: `default` or a number between 5000 and 10000."
  }

  validation {
    condition     = try(var.custom_values.ifc_other_rate == "default" || try(tonumber(var.custom_values.ifc_other_rate) >= 5000 && tonumber(var.custom_values.ifc_other_rate) <= 32800, false), var.custom_values.ifc_other_rate)
    error_message = "Allowed Values: `default` or a number between 5000 and 32800."
  }

  validation {
    condition     = try(var.custom_values.ifc_other_burst == "default" || try(tonumber(var.custom_values.ifc_other_burst) == 5000, false), var.custom_values.ifc_other_burst)
    error_message = "Allowed Values: `default` or the number 5000."
  }

  validation {
    condition     = try(var.custom_values.ifc_span_rate == "default" || try(tonumber(var.custom_values.ifc_span_rate) >= 10 && tonumber(var.custom_values.ifc_span_rate) <= 2000, false), var.custom_values.ifc_span_rate)
    error_message = "Allowed Values: `default` or a number between 10 and 2000."
  }

  validation {
    condition     = try(var.custom_values.ifc_span_burst == "default" || try(tonumber(var.custom_values.ifc_span_burst) >= 10 && tonumber(var.custom_values.ifc_span_burst) <= 2000, false), var.custom_values.ifc_span_burst)
    error_message = "Allowed Values: `default` or a number between 10 and 2000."
  }

  validation {
    condition     = try(var.custom_values.igmp_rate == "default" || try(tonumber(var.custom_values.igmp_rate) >= 10 && tonumber(var.custom_values.igmp_rate) <= 1500, false), var.custom_values.igmp_rate)
    error_message = "Allowed Values: `default` or a number between 10 and 1500."
  }

  validation {
    condition     = try(var.custom_values.igmp_burst == "default" || try(tonumber(var.custom_values.igmp_burst) >= 10 && tonumber(var.custom_values.igmp_burst) <= 1500, false), var.custom_values.igmp_burst)
    error_message = "Allowed Values: `default` or a number between 10 and 1500."
  }

  validation {
    condition     = try(var.custom_values.infra_arp_rate == "default" || try(tonumber(var.custom_values.infra_arp_rate) >= 50 && tonumber(var.custom_values.infra_arp_rate) <= 300, false), var.custom_values.infra_arp_rate)
    error_message = "Allowed Values: `default` or a number between 50 and 300."
  }

  validation {
    condition     = try(var.custom_values.infra_arp_burst == "default" || try(tonumber(var.custom_values.infra_arp_burst) >= 50 && tonumber(var.custom_values.infra_arp_burst) <= 300, false), var.custom_values.infra_arp_burst)
    error_message = "Allowed Values: `default` or a number between 50 and 300."
  }

  validation {
    condition     = try(var.custom_values.isis_rate == "default" || try(tonumber(var.custom_values.isis_rate) >= 100 && tonumber(var.custom_values.isis_rate) <= 1500, false), var.custom_values.isis_rate)
    error_message = "Allowed Values: `default` or a number between 100 and 1500."
  }

  validation {
    condition     = try(var.custom_values.isis_burst == "default" || try(tonumber(var.custom_values.isis_burst) >= 100 && tonumber(var.custom_values.isis_burst) <= 5000, false), var.custom_values.isis_burst)
    error_message = "Allowed Values: `default` or a number between 100 and 5000."
  }

  validation {
    condition     = try(var.custom_values.lldp_rate == "default" || try(tonumber(var.custom_values.lldp_rate) >= 10 && tonumber(var.custom_values.lldp_rate) <= 1000, false), var.custom_values.lldp_rate)
    error_message = "Allowed Values: `default` or a number between 10 and 1000."
  }

  validation {
    condition     = try(var.custom_values.lldp_burst == "default" || try(tonumber(var.custom_values.lldp_burst) >= 10 && tonumber(var.custom_values.lldp_burst) <= 1000, false), var.custom_values.lldp_burst)
    error_message = "Allowed Values: `default` or a number between 10 and 1000."
  }

  validation {
    condition     = try(var.custom_values.ospf_rate == "default" || try(tonumber(var.custom_values.ospf_rate) >= 10 && tonumber(var.custom_values.ospf_rate) <= 2000, false), var.custom_values.ospf_rate)
    error_message = "Allowed Values: `default` or a number between 10 and 2000."
  }

  validation {
    condition     = try(var.custom_values.ospf_burst == "default" || try(tonumber(var.custom_values.ospf_burst) >= 10 && tonumber(var.custom_values.ospf_burst) <= 2000, false), var.custom_values.ospf_burst)
    error_message = "Allowed Values: `default` or a number between 10 and 2000."
  }

  validation {
    condition     = try(var.custom_values.tor_glean_rate == "default" || try(tonumber(var.custom_values.tor_glean_rate) >= 10 && tonumber(var.custom_values.tor_glean_rate) <= 500, false), var.custom_values.tor_glean_rate)
    error_message = "Allowed Values: `default` or a number between 10 and 500."
  }

  validation {
    condition     = try(var.custom_values.tor_glean_burst == "default" || try(tonumber(var.custom_values.tor_glean_burst) >= 10 && tonumber(var.custom_values.tor_glean_burst) <= 500, false), var.custom_values.tor_glean_burst)
    error_message = "Allowed Values: `default` or a number between 10 and 500."
  }

  validation {
    condition     = try(var.custom_values.traceroute_rate == "default" || try(tonumber(var.custom_values.traceroute_rate) >= 10 && tonumber(var.custom_values.traceroute_rate) <= 500, false), var.custom_values.traceroute_rate)
    error_message = "Allowed Values: `default` or a number between 10 and 500."
  }

  validation {
    condition     = try(var.custom_values.traceroute_burst == "default" || try(tonumber(var.custom_values.traceroute_burst) >= 10 && tonumber(var.custom_values.traceroute_burst) <= 500, false), var.custom_values.traceroute_burst)
    error_message = "Allowed Values: `default` or a number between 10 and 500."
  }

}
