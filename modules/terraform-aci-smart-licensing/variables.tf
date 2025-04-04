variable "proxy_hostname_ip" {
  description = "Proxy Hostname or IP Address"
  type        = string
  default     = ""

  validation {
    condition     = var.proxy_hostname_ip == "" || can(regex("^[a-zA-Z0-9:\\[][a-zA-Z0-9.:-\\]]{0,254}$", var.proxy_hostname_ip))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `.`, `:`, `-`, `[`, `]`. Maximum characters: 254."
  }
}

variable "proxy_port" {
  description = "Proxy port"
  type        = string
  default     = "443"

  validation {
    condition     = try(tonumber(var.proxy_port) >= 0 && tonumber(var.proxy_port) <= 65535, false)
    error_message = "Allowed value is number between 0 and 65535."
  }
}

variable "mode" {
  description = "Mode"
  type        = string
  default     = "smart-licensing"

  validation {
    condition     = contains(["cslu", "smart-licensing", "offline", "plr", "proxy", "satellite", "transport-gateway"], var.mode)
    error_message = "Allowed values are: `cslu`, `smart-licensing`, `offline`, `plr`, `proxy`, `satellite`, `transport-gateway`"
  }
}

variable "registration_token" {
  description = "Registration token ID"
  type        = string
}

variable "url" {
  description = "URL"
  type        = string
  default     = null
}
