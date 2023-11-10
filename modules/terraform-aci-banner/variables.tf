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
