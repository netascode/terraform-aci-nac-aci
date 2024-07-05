variable "name" {
  description = "MACsec Policy Name"
  type = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.name))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "description" {
  description = "MACsec Policy description"
  type = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.description))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "adminSt" {
  description = "Administrative state of MACsec."
  type = bool
}

variable "cipherSuite" {
  description = "Ciper Suite. Choices: `gcm-aes-128`, `gcm-aes-128`, `gcm-aes-xpn-128`, `gcm-aes-xpn-256`.  Deafult is `gcm-aes-xpn-256`."
  type        = string
  default     = "gcm-aes-xpn-256"

  validation {
    condition     = contains(["gcm-aes-128", "gcm-aes-128", "gcm-aes-xpn-128", "gcm-aes-xpn-256"], var.cipherSuite)
    error_message = "Allowed values: `gcm-aes-128`, `gcm-aes-128`, `gcm-aes-xpn-128`, `gcm-aes-xpn-256`."
  }
}

variable "cakName" {
  description = "Connectivity Association Key Name (CKN)"
  type = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.cakName))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "keyName" {
  description = "Connectivity Association Key Name (CKN)"
  type = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.cakName))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "keyChain" {
  description = "Key Chain Name"
  type = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.keyChain))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "secPolicy" {
  description = "Security Policy. Choices are: `must-secure` or `should-secure`."
  type = string

  validation {
    condition     = contains(["should-secure", "must-secure"], var.secPolicy)
    error_message = "Allowed values: `must-secure` or `should-secure`."
  }
}