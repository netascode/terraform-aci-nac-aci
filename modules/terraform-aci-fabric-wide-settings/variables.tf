variable "domain_validation" {
  description = "Domain validation."
  type        = bool
  default     = false
}

variable "enforce_subnet_check" {
  description = "Enforce subnet check."
  type        = bool
  default     = false
}

variable "opflex_authentication" {
  description = "Opflex authentication."
  type        = bool
  default     = true
}

variable "disable_remote_endpoint_learn" {
  description = "Disable remote EP learn."
  type        = bool
  default     = false
}

variable "overlapping_vlan_validation" {
  description = "Overlapping VLAN validation."
  type        = bool
  default     = false
}

variable "remote_leaf_direct" {
  description = "Remote leaf direct."
  type        = bool
  default     = false
}

variable "reallocate_gipo" {
  description = "Reallocate GIPo"
  type        = bool
  default     = false
}
