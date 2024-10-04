variable "tenant" {
  description = "Multicast route map's tenant name."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.tenant))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "name" {
  description = "Multicast route map name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.name))
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

variable "entries" {

  description = "Multicast route map entries. `order` allowed range: `0-9999`. `action` allowed values: `permit` or `deny`. Default value `action`: `permit`."
  type = list(object({
    action    = optional(string, "permit")
    group_ip  = optional(string, "0.0.0.0")
    order     = number
    rp_ip     = optional(string, "0.0.0.0")
    source_ip = optional(string, "0.0.0.0")
  }))
  default = []

  validation {
    condition = alltrue([
      for entry in var.entries : entry.order >= 0 && entry.order <= 9999
    ])
    error_message = "`order`: Allowed range: `0-9999`."
  }

  validation {
    condition = alltrue([
      for entry in var.entries : try(contains(["permit", "deny"], entry.action), false)
    ])
    error_message = "`action`: Allowed values: `permit` or `deny`."
  }
}
