variable "name" {
  description = "Management access policy name."
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

variable "telnet_admin_state" {
  description = "Telnet admin state."
  type        = bool
  default     = false
}

variable "telnet_port" {
  description = "Telnet port."
  type        = number
  default     = 23

  validation {
    condition     = var.telnet_port >= 1 && var.telnet_port <= 65535
    error_message = "Minimum value: 1. Maximum value: 65535."
  }
}

variable "ssh_admin_state" {
  description = "SSH admin state."
  type        = bool
  default     = true
}

variable "ssh_port" {
  description = "SSH port."
  type        = number
  default     = 22

  validation {
    condition     = var.ssh_port >= 1 && var.ssh_port <= 65535
    error_message = "Minimum value: 1. Maximum value: 65535."
  }
}

variable "ssh_password_auth" {
  description = "SSH password authentication."
  type        = bool
  default     = true
}

variable "ssh_aes128_ctr" {
  description = "aes128-ctr cipher."
  type        = bool
  default     = true
}

variable "ssh_aes128_gcm" {
  description = "aes128-gcm cipher."
  type        = bool
  default     = true
}

variable "ssh_aes192_ctr" {
  description = "aes192-ctr cipher."
  type        = bool
  default     = true
}

variable "ssh_aes256_ctr" {
  description = "aes256-ctr cipher."
  type        = bool
  default     = true
}

variable "ssh_aes256_gcm" {
  description = "aes256-gcm cipher."
  type        = bool
  default     = false
}

variable "ssh_chacha" {
  description = "chacha cipher."
  type        = bool
  default     = true
}

variable "ssh_hmac_sha1" {
  description = "hmac-sha1 message authentication code."
  type        = bool
  default     = true
}

variable "ssh_hmac_sha2_256" {
  description = "hmac-sha2-256 message authentication code."
  type        = bool
  default     = true
}

variable "ssh_hmac_sha2_512" {
  description = "hmac-sha2-512 message authentication code."
  type        = bool
  default     = true
}

variable "ssh_curve25519_sha256" {
  description = "curve25519-sha256 kex algorithm."
  type        = bool
  default     = false
}

variable "ssh_curve25519_sha256_libssh" {
  description = "curve25519-sha256 libssh.org kex algorithm."
  type        = bool
  default     = false
}

variable "ssh_dh1_sha1" {
  description = "diffie-hellman-group1-sha1 kex algorithm."
  type        = bool
  default     = false
}

variable "ssh_dh14_sha1" {
  description = "diffie-hellman-group14-sha1 kex algorithm."
  type        = bool
  default     = false
}

variable "ssh_dh14_sha256" {
  description = "diffie-hellman-group14-sha256 kex algorithm."
  type        = bool
  default     = false
}

variable "ssh_dh16_sha512" {
  description = "diffie-hellman-group16-sha512 kex algorithm."
  type        = bool
  default     = false
}

variable "ssh_ecdh_sha2_nistp256" {
  description = "ecdh-sha2-nistp256 kex algorithm."
  type        = bool
  default     = false
}

variable "ssh_ecdh_sha2_nistp384" {
  description = "ecdh-sha2-nistp384 kex algorithm."
  type        = bool
  default     = false
}

variable "ssh_ecdh_sha2_nistp521" {
  description = "ecdh-sha2-nistp521 kex algorithm."
  type        = bool
  default     = false
}

variable "https_admin_state" {
  description = "HTTPS admin state."
  type        = bool
  default     = false
}

variable "https_client_cert_auth_state" {
  description = "HTTPS client certificate authentication state."
  type        = bool
  default     = false
}

variable "https_port" {
  description = "HTTPS port."
  type        = number
  default     = 443

  validation {
    condition     = var.https_port >= 1 && var.https_port <= 65535
    error_message = "Minimum value: 1. Maximum value: 65535."
  }
}

variable "https_dh" {
  description = "HTTPS Diffie-Hellman group. Choices: `1024`, `2048`, `4096` or `none`."
  type        = string
  default     = "none"

  validation {
    condition     = contains(["1024", "2048", "4096", "none"], var.https_dh)
    error_message = "Allowed values: `1024`, `2048`, `4096` or `none`."
  }
}

variable "https_tlsv1" {
  description = "HTTPS TLS v1."
  type        = bool
  default     = false
}

variable "https_tlsv1_1" {
  description = "HTTPS TLS v1.1."
  type        = bool
  default     = true
}

variable "https_tlsv1_2" {
  description = "HTTPS TLS v1.2."
  type        = bool
  default     = true
}

variable "https_tlsv1_3" {
  description = "HTTPS TLS v1.3."
  type        = bool
  default     = false
}

variable "https_keyring" {
  description = "HTTPS keyring name."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.https_keyring))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "https_allow_origins" {
  description = "HTTPS allow origins."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9-_:/.,]{0,256}$", var.https_allow_origins))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `,` `:`, `-` `/`. Maximum characters: 256."
  }
}

variable "http_admin_state" {
  description = "HTTP admin state."
  type        = bool
  default     = false
}

variable "http_port" {
  description = "HTTP port."
  type        = number
  default     = 80

  validation {
    condition     = var.http_port >= 1 && var.http_port <= 65535
    error_message = "Minimum value: 1. Maximum value: 65535."
  }
}

variable "http_allow_origins" {
  description = "HTTP allow origins."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9-_:/.,]{0,256}$", var.http_allow_origins))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `,` `:`, `-` `/`. Maximum characters: 256."
  }
}
