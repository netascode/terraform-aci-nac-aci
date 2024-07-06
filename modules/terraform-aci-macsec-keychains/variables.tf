variable "name" {
  description = "MACsec Key Policy Name"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.name))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "description" {
  description = "MACsec Policy description"
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.description))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "key_policies" {
  description = "Key Polices for Key Chain"
  type        = list(map(string))
  default     = []

  validation {
    condition = alltrue([
      for kp in var.key_policies : can(regex("^[a-fA-F0-9]{0,64}$", kp.name))
    ])
    error_message = "`name`: Allowed characters: `a`-`f`, `A`-`F`, `0`-`9`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for kp in var.key_policies : can(regex("^[a-fA-F0-9]{0,64}$", kp.keyName))
    ])
    error_message = "`keyName`: Allowed characters: `a`-`f`, `A`-`F`, `0`-`9`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for kp in var.key_policies : can(regex("^[a-fA-F0-9]{0,64}$", kp.preSharedKey))
    ])
    error_message = "`keyName`: Allowed characters: `a`-`f`, `A`-`F`, `0`-`9`. Maximum characters: 64."
  }

  # Validate startTime ?

  # Validate endTime ?
}
