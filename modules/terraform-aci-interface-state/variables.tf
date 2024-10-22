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
  description = "Interface Module. Minimum value: `1`. Maximum value: `255`."
  type        = number
  default     = 1

  validation {
    condition     = try(var.module >= 1 && var.module <= 255, false)
    error_message = "Allowed values: 1-255."
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

variable "sub_port" {
  description = "Subinterface ID. Allowed values: 1-64."
  type        = number
  default     = 0

  validation {
    condition     = try(var.sub_port >= 0 && var.sub_port <= 64, false)
    error_message = "Allowed values: 1-64."
  }
}

variable "shutdown" {
  description = "Shutdown interface."
  type        = bool
  default     = false
}



