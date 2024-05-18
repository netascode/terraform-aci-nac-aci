variable "name" {
  description = "Date time policy Name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.name))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "apic_ntp_server_master_stratum" {
  description = "APIC NTP server master stratum. Minimum value: 1. Maximum value: 14."
  type        = number
  default     = 8

  validation {
    condition     = var.apic_ntp_server_master_stratum >= 1 && var.apic_ntp_server_master_stratum <= 14
    error_message = "Minimum value: 1. Maximum value: 14."
  }
}

variable "ntp_admin_state" {
  description = "NTP admin state."
  type        = bool
  default     = true
}

variable "ntp_auth_state" {
  description = "NTP authentication state."
  type        = bool
  default     = false
}

variable "apic_ntp_server_master_mode" {
  description = "APIC NTP server master mode."
  type        = bool
  default     = false
}

variable "apic_ntp_server_state" {
  description = "APIC NTP server state."
  type        = bool
  default     = false
}

variable "ntp_servers" {
  description = "List of NTP servers. Default value `preferred`: false. Choices `mgmt_epg_type`: `inb`, `oob`. Default value `mgmt_epg_type`: `inb`. Allowed values `auth_key_id`: 1-65535."
  type = list(object({
    hostname_ip   = string
    preferred     = optional(bool, false)
    mgmt_epg_type = optional(string, "inb")
    mgmt_epg_name = optional(string)
    auth_key_id   = optional(number)
  }))
  default = []

  validation {
    condition = alltrue([
      for s in var.ntp_servers : s.mgmt_epg_type == null || try(contains(["inb", "oob"], s.mgmt_epg_type), false)
    ])
    error_message = "`mgmt_epg_type`: Allowed values are `inb` or `oob`."
  }

  validation {
    condition = alltrue([
      for s in var.ntp_servers : can(regex("^[a-zA-Z0-9_.:-]{0,64}$", s.mgmt_epg_name))
    ])
    error_message = "`mgmt_epg_name`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for s in var.ntp_servers : s.auth_key_id == null || try(s.auth_key_id >= 1 && s.auth_key_id <= 65535, false)
    ])
    error_message = "`auth_key_id`: Minimum value: `1`. Maximum value: `65535`."
  }
}

variable "ntp_keys" {
  description = "List of keys. Allowed values `id`: 1-65535. Choices `auth_type`: `md5`, `sha1`."
  type = list(object({
    id        = number
    key       = string
    auth_type = string
    trusted   = bool
  }))
  default = []

  validation {
    condition = alltrue([
      for k in var.ntp_keys : k.id >= 1 && k.id <= 65535
    ])
    error_message = "`id`: Minimum value: `1`. Maximum value: `65535`."
  }

  validation {
    condition = alltrue([
      for k in var.ntp_keys : contains(["md5", "sha1"], k.auth_type)
    ])
    error_message = "`auth_type`: Allowed values are `md5` or `sha1`."
  }
}
