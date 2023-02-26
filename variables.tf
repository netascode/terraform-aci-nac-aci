variable "yaml_directories" {
  description = "List of paths to YAML directories."
  type        = list(string)
  default     = []
}

variable "yaml_files" {
  description = "List of paths to YAML files."
  type        = list(string)
  default     = []
}

variable "model" {
  description = "As an alternative to YAML files, a native Terraform data structure can be provided as well."
  type        = map(any)
  default     = {}
}

variable "manage_access_policies" {
  description = "Flag to indicate if access policies should be managed."
  type        = bool
  default     = false
}

variable "manage_fabric_policies" {
  description = "Flag to indicate if fabric policies should be managed."
  type        = bool
  default     = false
}

variable "manage_pod_policies" {
  description = "Flag to indicate if pod policies should be managed."
  type        = bool
  default     = false
}

variable "manage_node_policies" {
  description = "Flag to indicate if node policies should be managed."
  type        = bool
  default     = false
}

variable "manage_interface_policies" {
  description = "Flag to indicate if interface policies should be managed."
  type        = bool
  default     = false
}

variable "managed_interface_policies_nodes" {
  description = "List of node IDs for which interface policies should be managed. By default interface policies for all nodes will be managed."
  type        = list(number)
  default     = []
}

variable "manage_tenants" {
  description = "Flag to indicate if tenants should be managed."
  type        = bool
  default     = false
}

variable "managed_tenants" {
  description = "List of tenant names to be managed. By default all tenants will be managed."
  type        = list(string)
  default     = []
}

variable "write_default_values_file" {
  description = "Write all default values to a YAML file. Value is a path pointing to the file to be created."
  type        = string
  default     = ""
}
