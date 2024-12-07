variable "name" {
  description = "MACsec Parameter Policy Name"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.name))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "description" {
  description = "MACsec Parameter Policy description"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", var.description))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, }`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }
}

variable "cipher_suite" {
  description = "Ciper Suite. Choices: `gcm-aes-128`, `gcm-aes-256`, `gcm-aes-xpn-128`, `gcm-aes-xpn-256`.  Deafult is `gcm-aes-xpn-256`."
  type        = string
  default     = "gcm-aes-xpn-256"

  validation {
    condition     = contains(["gcm-aes-128", "gcm-aes-256", "gcm-aes-xpn-128", "gcm-aes-xpn-256"], var.cipher_suite)
    error_message = "Allowed values: `gcm-aes-128`, `gcm-aes-256`, `gcm-aes-xpn-128`, `gcm-aes-xpn-256`."
  }
}

variable "confidentiality_offset" {
  description = "Confidentiality Offset. Choices: `offset-0`, `offset-30`, `offset-50`. Default is `offset-0`."
  type        = string
  default     = "offset-0"

  validation {
    condition     = contains(["offset-0", "offset-30", "offset-50"], var.confidentiality_offset)
    error_message = "Allowed values: `offset-0`, `offset-30`, `offset-50`"
  }
}

variable "key_server_priority" {
  description = "Key Server Priority. Minimum value: `0`. Maximum value: `255`. Default: `16`"
  type        = number
  default     = 16

  validation {
    condition     = var.key_server_priority >= 0 && var.key_server_priority <= 255
    error_message = "Minimum value: `0`. Maximum value: `255`."
  }
}

variable "window_size" {
  description = "Replay Protection Window Size. Minimum value: `0`. Maximum value `4294967295`. Default: `64`"
  type        = number
  default     = 64

  validation {
    condition     = var.window_size >= 0 && var.window_size <= 4294967295
    error_message = "Minimum value: `0`. Maximum value: `4294967295`."
  }
}

variable "key_expiry_time" {
  description = "SAK Expiry Time (in seconds). Values are `0` (disabled); or Minimum value `60`, Maximum value `2592000`"
  type        = number
  default     = 0

  validation {
    condition     = var.key_expiry_time == 0 || (var.key_expiry_time >= 60 && var.key_expiry_time <= 2592000)
    error_message = "Allowed values: `0` (disabled); or Minimum value `60`, Maximum value `2592000`"
  }
}

variable "security_policy" {
  description = "Security Policy. Choices are: `must-secure` or `should-secure`."
  type        = string
  default     = "should-secure"

  validation {
    condition     = contains(["should-secure", "must-secure"], var.security_policy)
    error_message = "Allowed values: `must-secure` or `should-secure`."
  }
}
