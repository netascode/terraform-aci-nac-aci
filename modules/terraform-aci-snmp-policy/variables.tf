variable "name" {
  description = "SNMP policy name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.name))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "admin_state" {
  description = "Admin state."
  type        = bool
  default     = false
}

variable "location" {
  description = "Location."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^.{0,512}$", var.location))
    error_message = "Maximum characters: 512."
  }
}

variable "contact" {
  description = "Contact."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^.{0,255}$", var.contact))
    error_message = "Maximum characters: 255."
  }
}

variable "communities" {
  description = "List of communities."
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for c in var.communities : can(regex("^.{0,32}$", c))
    ])
    error_message = "Maximum characters: 32."
  }
}

variable "users" {
  description = "List of users. Choices `privacy_type`: `none`, `des`, `aes-128`. Default value `privacy_type`: `none`. `privacy_key`: Minimum characters: 8. Maximum characters: 130. Choices `authorization_type`: `hmac-md5-96`, `hmac-sha1-96`, `hmac-sha2-224`, `hmac-sha2-256`, `hmac-sha2-384`, `hmac-sha2-512`. Default value `authorization_type`: `mac-md5-96`. `authorization_key`: Minimum characters: 8. Maximum characters: 130."
  type = list(object({
    name               = string
    privacy_type       = optional(string, "none")
    privacy_key        = optional(string)
    authorization_type = optional(string, "hmac-md5-96")
    authorization_key  = optional(string, "")
  }))
  default = []

  validation {
    condition = alltrue([
      for u in var.users : can(regex("^[a-zA-Z0-9_.:-]{1,64}$", u.name))
    ])
    error_message = "Allowed characters `name`: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for u in var.users : u.privacy_type == null || try(contains(["none", "des", "aes-128"], u.privacy_type), false)
    ])
    error_message = "`privacy_type`: Allowed values are `none`, `des` or `aes-128`."
  }

  validation {
    condition = alltrue([
      for u in var.users : u.privacy_key == null || try(can(regex("^.{8,130}$", u.privacy_key)), false)
    ])
    error_message = "`privacy_key`: Minimum characters: 8. Maximum characters: 130."
  }

  validation {
    condition = alltrue([
      for u in var.users : u.authorization_type == null || try(contains(["hmac-md5-96", "hmac-sha1-96", "hmac-sha2-224", "hmac-sha2-256", "hmac-sha2-384", "hmac-sha2-512"], u.authorization_type), false)
    ])
    error_message = "`authorization_type`: Allowed values are `hmac-md5-96` or `hmac-sha1-96`."
  }

  validation {
    condition = alltrue([
      for u in var.users : u.authorization_key == null || try(can(regex("^.{8,130}$", u.authorization_key)), false)
    ])
    error_message = "`authorization_key`: Minimum characters: 8. Maximum characters: 130."
  }
}

variable "trap_forwarders" {
  description = "List of trap forwarders. Allowed values `port`: 0-65535. Default value `port`: 162."
  type = list(object({
    ip   = string
    port = optional(number, 162)
  }))
  default = []

  validation {
    condition = alltrue([
      for t in var.trap_forwarders : t.port == null || try(t.port >= 0 && t.port <= 65535, false)
    ])
    error_message = "`port`: Minimum value: 0. Maximum value: 65535."
  }
}

variable "clients" {
  description = "List of clients. Choices `mgmt_epg_type`: `inb`, `oob`. Default value `mgmt_epg_type`: `inb`."
  type = list(object({
    name          = string
    mgmt_epg_type = optional(string, "inb")
    mgmt_epg_name = optional(string)
    entries = optional(list(object({
      ip   = string
      name = string
    })), [])
  }))
  default = []

  validation {
    condition = alltrue([
      for c in var.clients : can(regex("^[a-zA-Z0-9_.:-]{1,64}$", c.name))
    ])
    error_message = "Allowed characters `name`: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for c in var.clients : c.mgmt_epg_type == null || try(contains(["inb", "oob"], c.mgmt_epg_type), false)
    ])
    error_message = "`mgmt_epg_type`: Allowed values are `inb` or `oob`."
  }

  validation {
    condition = alltrue([
      for c in var.clients : can(regex("^[a-zA-Z0-9_.:-]{1,64}$", c.mgmt_epg_name))
    ])
    error_message = "Allowed characters `mgmt_epg_name`: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue(flatten([
      for c in var.clients : [for e in coalesce(c.entries, []) : can(regex("^[a-zA-Z0-9_.-]{0,64}$", e.name))]
    ]))
    error_message = "`entries.name`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}
