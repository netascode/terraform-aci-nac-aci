variable "name" {
  description = "Link level interface policy name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.name))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "speed" {
  description = "Interface speed. Choices: `inherit`, `auto`, `100M`, `1G`, `10G`, `25G`, `40G`, `100G`, `400G`."
  type        = string
  default     = "inherit"

  validation {
    condition     = contains(["inherit", "auto", "100M", "1G", "10G", "25G", "40G", "100G", "400G"], var.speed)
    error_message = "Allowed values: `inherit`, `auto`, `100M`, `1G`, `10G`, `25G`, `40G`, `100G` or `400G`."
  }
}

variable "auto" {
  description = "Auto negotiation."
  type        = bool
  default     = true
}

variable "fec_mode" {
  description = "Forward error correction (FEC) mode. Choices: `inherit`, `cl91-rs-fec`, `cl74-fc-fec`, `ieee-rs-fec`, `cons16-rs-fec`, `disable-fec`."
  type        = string
  default     = "inherit"

  validation {
    condition     = contains(["inherit", "cl91-rs-fec", "cl74-fc-fec", "ieee-rs-fec", "cons16-rs-fec", "disable-fec"], var.fec_mode)
    error_message = "Allowed values: `inherit`, `cl91-rs-fec`, `cl74-fc-fec`, `ieee-rs-fec`, `cons16-rs-fec`, `disable-fec`."
  }
}
