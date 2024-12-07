variable "name" {
  description = "Netflow Exporter name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.name))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "description" {
  description = "Netflow Exporter description."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9\\\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", var.description))
    error_message = "Allowed values are: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, }`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }
}

variable "dscp" {
  description = "Netflow Exporter DSCP. Choices: `CS0`, `CS1`, `AF11`, `AF12`, `AF13`, `CS2`, `AF21`, `AF22`, `AF23`, `CS3`, `AF31`, `AF32`, `AF33`, `CS4`, `AF41`, `AF42`, `AF43`, `CS5`, `VA`, `EF`, `CS6`, `CS7`, `unspecified` or a number between `0` and `63`."
  type        = string
  default     = "unspecified"

  validation {
    condition     = contains(["CS0", "CS1", "AF11", "AF12", "AF13", "CS2", "AF21", "AF22", "AF23", "CS3", "AF31", "AF32", "AF33", "CS4", "AF41", "AF42", "AF43", "CS5", "VA", "EF", "CS6", "CS7", "unspecified"], var.dscp) || try(var.dscp >= 0 && var.dscp <= 63, false)
    error_message = "Allowed values are `CS0`, `CS1`, `AF11`, `AF12`, `AF13`, `CS2`, `AF21`, `AF22`, `AF23`, `CS3`, `AF31`, `AF32`, `AF33`, `CS4`, `AF41`, `AF42`, `AF43`, `CS5`, `VA`, `EF`, `CS6`, `CS7`, `unspecified or a number between `0` and `63`."
  }
}

variable "destination_ip" {
  description = "Netflow Exporter destination address."
  type        = string
}


variable "destination_port" {
  description = "Netflow Exporter destination port."
  type        = string

  validation {
    condition     = var.destination_port >= 0 && var.destination_port <= 65535
    error_message = "Minimum value: 0, Maximum value: 65535."
  }
}

variable "source_ip" {
  description = "Netflow Exporter source address."
  type        = string
  default     = "0.0.0.0"
}


variable "source_type" {
  description = "Netflow Exporter source type. Allowed values: `custom-src-ip`, `inband-mgmt-ip`, `oob-mgmt-ip`, `ptep`."
  type        = string

  validation {
    condition     = contains(["custom-src-ip", "inband-mgmt-ip", "oob-mgmt-ip", "ptep"], var.source_type)
    error_message = "Allowed values: `custom-src-ip`, `inband-mgmt-ip`, `oob-mgmt-ip`, `ptep`."
  }
}

variable "epg_type" {
  description = "Netflow Exporter EPG type. Allowed values: `epg`, `external_epg`."
  type        = string
  default     = ""

  validation {
    condition     = contains(["", "epg", "external_epg"], var.epg_type)
    error_message = "Allowed values: `epg`, `external_epg`."
  }
}

variable "tenant" {
  description = "Netflow Exporter tenant name."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.tenant))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "application_profile" {
  description = "Netflow Exporter application profile name."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.application_profile))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "endpoint_group" {
  description = "Netflow Exporter endpoint group name."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.endpoint_group))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "vrf" {
  description = "Netflow Exporter VRF name."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.vrf))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "l3out" {
  description = "Netflow Exporter L3out name."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.l3out))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "external_endpoint_group" {
  description = "Netflow Exporter external endpoint group name."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.external_endpoint_group))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}