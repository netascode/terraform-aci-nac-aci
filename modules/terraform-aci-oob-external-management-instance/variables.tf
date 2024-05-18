variable "name" {
  description = "OOB external management instance name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.name))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "subnets" {
  description = "Subnets"
  type        = list(string)
  default     = []
}

variable "oob_contract_consumers" {
  description = "List of OOB contract consumers."
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for c in var.oob_contract_consumers : can(regex("^[a-zA-Z0-9_.:-]{0,64}$", c))
    ])
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}
