variable "node_id" {
  description = "Node ID. Minimum value: 101. Maximum value: 4000."
  type        = number

  validation {
    condition     = var.node_id >= 101 && var.node_id <= 4000
    error_message = "Minimum value: 101. Maximum value: 4000."
  }
}

variable "port_rules" {
  description = "List of RBAC Port Rules for Node."
  type = list(object({
    name   = string
    domain = string
  }))

  validation {
    condition = alltrue([
      for rule in var.port_rules : can(regex("^[a-zA-Z0-9_.:-]{1,64}$", rule.name))
    ])
    error_message = "`port_rules.name` allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for rule in var.port_rules : can(regex("^[a-zA-Z][a-zA-Z0-9_.-]{0,31}$", rule.domain))
    ])
    error_message = "`port_rules.domain` allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Allowed first character: `a`-`z`, `A`-`Z`. Maximum characters: 32."
  }
}
