variable "pod_id" {
  description = "Interface Pod ID. Minimum value: `1`. Maximum value: `255`."
  type        = number
  default     = 1

  validation {
    condition     = var.pod_id >= 1 && var.pod_id <= 255
    error_message = "Minimum value: `1`. Maximum value: `255`."
  }
}

variable "node_id" {
  description = "Interface Node ID. Minimum value: `1`. Maximum value: `4000`."
  type        = number

  validation {
    condition     = var.node_id >= 1 && var.node_id <= 4000
    error_message = "Minimum value: `1`. Maximum value: `4000`."
  }
}

variable "module" {
  description = "Interface Module. Minimum value: `1`. Maximum value: `9`."
  type        = number
  default     = 1

  validation {
    condition     = var.module >= 1 && var.module <= 9
    error_message = "Minimum value: `1`. Maximum value: `9`."
  }
}

variable "port" {
  description = "Interface Port. Minimum value: `1`. Maximum value: `127`."
  type        = number

  validation {
    condition     = var.port >= 1 && var.port <= 127
    error_message = "Minimum value: `1`. Maximum value: `127`."
  }
}

variable "type" {
  description = "Interface Type. Valid values are `uplink` or `downlink`"
  type        = string

  validation {
    condition     = contains(["uplink", "downlink"], var.type)
    error_message = "Valid values are `uplink` or `downlink`."
  }
}

