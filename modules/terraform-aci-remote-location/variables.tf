variable "name" {
  description = "Remote location name."
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

variable "hostname_ip" {
  description = "Hostname or IP."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9:][a-zA-Z0-9.:-]{0,254}$", var.hostname_ip))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `.`, `:`, `-`. Maximum characters: 254."
  }
}

variable "auth_type" {
  description = "Authentication type. Choices: `password`, `ssh_keys`."
  type        = string
  default     = "password"

  validation {
    condition     = contains(["password", "ssh_keys"], var.auth_type)
    error_message = "Allowed values are `password` or `ssh_keys`."
  }
}

variable "protocol" {
  description = "Protocol. Choices: `ftp`, `sftp`, `scp`."
  type        = string
  default     = "sftp"

  validation {
    condition     = contains(["ftp", "sftp", "scp"], var.protocol)
    error_message = "Allowed values are `ftp`, `sftp` or `scp`."
  }
}

variable "path" {
  description = "Path."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^.{0,512}$", var.path))
    error_message = "Maximum characters: 512."
  }
}

variable "port" {
  description = "Port. Allowed values: 0-65535."
  type        = number
  default     = 0

  validation {
    condition     = var.port >= 0 && var.port <= 65535
    error_message = "Minimum value: 0. Maximum value: 65535."
  }
}

variable "username" {
  description = "Username."
  type        = string
  default     = ""

  validation {
    condition     = var.username == "" || can(regex("^[a-zA-Z0-9][a-zA-Z0-9_.@\\\\-]{0,31}$", var.username))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `@`, `\\` or `-`. Maximum characters: 31."
  }
}

variable "password" {
  description = "Password."
  type        = string
  default     = ""
  sensitive   = true
}

variable "ssh_private_key" {
  description = "SSH private key."
  type        = string
  default     = ""
  sensitive   = true
}

variable "ssh_public_key" {
  description = "SSH public key."
  type        = string
  default     = ""
}

variable "ssh_passphrase" {
  description = "SSH passphrase."
  type        = string
  default     = ""
  sensitive   = true

  validation {
    condition     = can(regex("^.{0,512}$", var.ssh_passphrase))
    error_message = "Maximum characters: 512."
  }
}

variable "mgmt_epg_type" {
  description = "Management EPG type. Choices: `inb`, `oob`."
  type        = string
  default     = "inb"

  validation {
    condition     = contains(["inb", "oob"], var.mgmt_epg_type)
    error_message = "Allowed values are `inb` or `oob`."
  }
}

variable "mgmt_epg_name" {
  description = "Management EPG name."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.mgmt_epg_name))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

