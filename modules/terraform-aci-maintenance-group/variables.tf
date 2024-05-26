variable "name" {
  description = "Maintenance group name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.name))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "target_version" {
  description = "Target version."
  type        = string
  default     = ""

  validation {
    condition     = var.target_version == "" || can(regex("n\\d+-\\d+\\.\\d+\\(\\w+\\)", var.target_version))
    error_message = "Invalid version number."
  }
}

variable "node_ids" {
  description = "List of node IDs. Minimum value: 1. Maximum value: 4000."
  type        = list(number)
  default     = []

  validation {
    condition = alltrue([
      for id in var.node_ids : id >= 1 && id <= 4000
    ])
    error_message = "Minimum value: 1. Maximum value: 4000."
  }
}
