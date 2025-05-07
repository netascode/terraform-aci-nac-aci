variable "apic_gui_banner_message" {
  description = "APIC GUI banner message. Either a GUI banner message or a GUI banner URL can be used, but not both."
  type        = string
  default     = ""
}

variable "apic_gui_banner_url" {
  description = "APIC GUI banner URL."
  type        = string
  default     = ""
}

variable "apic_gui_alias" {
  description = "APIC GUI alias."
  type        = string
  default     = ""
}
variable "apic_cli_banner" {
  description = "APIC CLI banner."
  type        = string
  default     = ""
}
variable "switch_cli_banner" {
  description = "Switch CLI banner."
  type        = string
  default     = ""
}

variable "apic_app_banner" {
  description = "APIC Application banner."
  type        = string
  default     = ""
}

variable "apic_app_banner_severity" {
  type        = string
  description = "Severity level for the APIC Application banner. Allowed values: info, critical, warning."
  default     = "info"

  validation {
    condition     = contains(["info", "critical", "warning"], var.apic_app_banner_severity)
    error_message = "Invalid severity: must be one of 'info', 'critical', or 'warning'."
  }
}

variable "escape_html" {
  description = "Enable escape HTML characters for banner."
  type        = bool
  default     = true
}
