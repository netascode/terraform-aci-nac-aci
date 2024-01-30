variable "node_id" {
  description = "Node ID. Allowed values: 101-16000."
  type        = number

  validation {
    condition     = try(var.node_id >= 101 && var.node_id <= 16000, false)
    error_message = "Allowed values: 101-16000."
  }
}

variable "access_policy_group" {
  description = "Access switch policy group name."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.access_policy_group))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "fabric_policy_group" {
  description = "Fabric switch policy group name."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.fabric_policy_group))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "role" {
  description = "Node role. Allowed values: `leaf`, `spine`."
  type        = string
  default     = "leaf"

  validation {
    condition     = contains(["leaf", "spine"], var.role)
    error_message = "Allowed values: `leaf`, `spine`."
  }
}
