variable "http_url" {
  description = "HTTP proxy URL, e.g. `http://proxy.example.com:8080`."
  type        = string
  default     = ""

  validation {
    condition     = var.http_url == "" || can(regex("^https?://.{1,504}$", var.http_url))
    error_message = "Must start with `http://` or `https://`. Maximum characters: 512."
  }
}

variable "http_username" {
  description = "Username for the HTTP proxy. Embedded into the HTTP URL when set."
  type        = string
  default     = ""

  validation {
    condition     = length(var.http_username) <= 128
    error_message = "Maximum characters: 128."
  }
}

variable "http_password" {
  description = "Password for the HTTP proxy. Embedded into the HTTP URL when set."
  type        = string
  default     = ""
  sensitive   = true

  validation {
    condition     = length(var.http_password) <= 128
    error_message = "Maximum characters: 128."
  }
}

variable "https_url" {
  description = "HTTPS proxy URL, e.g. `https://proxy.example.com:8443`."
  type        = string
  default     = ""

  validation {
    condition     = var.https_url == "" || can(regex("^https?://.{1,504}$", var.https_url))
    error_message = "Must start with `http://` or `https://`. Maximum characters: 512."
  }
}

variable "https_username" {
  description = "Username for the HTTPS proxy. Embedded into the HTTPS URL when set."
  type        = string
  default     = ""

  validation {
    condition     = length(var.https_username) <= 128
    error_message = "Maximum characters: 128."
  }
}

variable "https_password" {
  description = "Password for the HTTPS proxy. Embedded into the HTTPS URL when set."
  type        = string
  default     = ""
  sensitive   = true

  validation {
    condition     = length(var.https_password) <= 128
    error_message = "Maximum characters: 128."
  }
}

variable "ignore_hosts" {
  description = "List of hostnames or IP addresses that should bypass the proxy."
  type        = list(string)
  default     = []

  validation {
    condition     = alltrue([for h in var.ignore_hosts : can(regex("^[a-zA-Z0-9:\\[][a-zA-Z0-9.:\\-\\]]{0,254}$", h))])
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `.`, `:`, `-`, `[`, `]`. Maximum characters: 255."
  }
}
