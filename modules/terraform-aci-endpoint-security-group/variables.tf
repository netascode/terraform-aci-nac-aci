variable "name" {
  description = "Endpoint security group name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.name))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "tenant" {
  description = "Tenant name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.tenant))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "application_profile" {
  description = "Application profile name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.application_profile))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "description" {
  description = "Description."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9\\\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", var.description))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, }`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }
}

variable "vrf" {
  description = "VRF name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.vrf))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "shutdown" {
  description = "Shutdown."
  type        = bool
  default     = false
}

variable "intra_esg_isolation" {
  description = "Intra ESG isolation."
  type        = bool
  default     = false
}

variable "preferred_group" {
  description = "Preferred group membership."
  type        = bool
  default     = false
}

variable "contract_consumers" {
  description = "List of contract consumers."
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for c in var.contract_consumers : can(regex("^[a-zA-Z0-9_.:-]{0,64}$", c))
    ])
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "contract_providers" {
  description = "List of contract providers."
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for c in var.contract_providers : can(regex("^[a-zA-Z0-9_.:-]{0,64}$", c))
    ])
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "contract_imported_consumers" {
  description = "List of imported contract consumers."
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for c in var.contract_imported_consumers : can(regex("^[a-zA-Z0-9_.:-]{0,64}$", c))
    ])
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "contract_intra_esgs" {
  description = "List of intra-ESG contracts."
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for c in var.contract_intra_esgs : can(regex("^[a-zA-Z0-9_.:-]{0,64}$", c))
    ])
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "esg_contract_masters" {
  description = "List of ESG contract masters."
  type = list(object({
    tenant                  = string
    application_profile     = string
    endpoint_security_group = string
  }))
  default = []

  validation {
    condition = alltrue([
      for ecm in var.esg_contract_masters : can(regex("^[a-zA-Z0-9_.:-]{0,64}$", ecm.tenant))
    ])
    error_message = "`tenant`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for ecm in var.esg_contract_masters : can(regex("^[a-zA-Z0-9_.:-]{0,64}$", ecm.application_profile))
    ])
    error_message = "`application_profile`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for ecm in var.esg_contract_masters : can(regex("^[a-zA-Z0-9_.:-]{0,64}$", ecm.endpoint_security_group))
    ])
    error_message = "`endpoint_security_group`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "tag_selectors" {
  description = "List of tag selectors.  Choices `operator`: `contains`, `equals`, `regex`. Default value `operator`: `equals`."
  type = list(object({
    key         = string
    operator    = optional(string, "equals")
    value       = string
    description = optional(string, "")
  }))
  default = []

  validation {
    condition = alltrue([
      for ts in var.tag_selectors : can(regex("^[a-zA-Z0-9_.\\\\:-]{0,64}$", ts.key))
    ])
    error_message = "`key`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `\\`, `-`, `:`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for ts in var.tag_selectors : ts.operator == null || try(contains(["contains", "equals", "regex"], ts.operator), false)
    ])
    error_message = "`operator`: Valid values are `contains`, `equals` or `regex`."
  }

  validation {
    condition = alltrue([
      for ts in var.tag_selectors : can(regex("^[a-zA-Z0-9_.,:^$\\[\\]\\(\\)\\{\\}\\\\|+*-]{0,128}$", ts.value))
    ])
    error_message = "`value`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `,`, `:`, `^`, `$`, `-`, `[`, `]`, `\\`, `(`, `)`, `{`, `}`, `|`, `+`, `*`, `-`. Maximum characters: 128."
  }

  validation {
    condition = alltrue([
      for ts in var.tag_selectors : ts.description == null || can(regex("^[a-zA-Z0-9\\\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", ts.description))
    ])
    error_message = "`description`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, }`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }
}

variable "epg_selectors" {
  description = "List of EPG selectors."
  type = list(object({
    tenant              = string
    application_profile = string
    endpoint_group      = string
    description         = optional(string, "")
  }))
  default = []

  validation {
    condition = alltrue([
      for epgs in var.epg_selectors : can(regex("^[a-zA-Z0-9_.:-]{0,64}$", epgs.tenant))
    ])
    error_message = "`tenant`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for epgs in var.epg_selectors : can(regex("^[a-zA-Z0-9_.:-]{0,64}$", epgs.application_profile))
    ])
    error_message = "`application_profile`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for epgs in var.epg_selectors : can(regex("^[a-zA-Z0-9_.:-]{0,64}$", epgs.endpoint_group))
    ])
    error_message = "`endpoint_group`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for epgs in var.epg_selectors : epgs.description == null || can(regex("^[a-zA-Z0-9\\\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", epgs.description))
    ])
    error_message = "`description`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, }`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }
}

variable "ip_subnet_selectors" {
  description = "List of IP subnet selectors."
  type = list(object({
    value       = string
    description = optional(string, "")
  }))
  default = []

  validation {
    condition = alltrue([
      for iss in var.ip_subnet_selectors : can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}\\/([0-9]){1,2}$", iss.value))
    ])
    error_message = "`value`: Valid ip format example: 192.168.1.0/24."
  }

  validation {
    condition = alltrue([
      for iss in var.ip_subnet_selectors : iss.description == null || can(regex("^[a-zA-Z0-9\\\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", iss.description))
    ])
    error_message = "`description`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, }`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }
}
