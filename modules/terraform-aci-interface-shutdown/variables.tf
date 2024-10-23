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
    condition     = var.node_id >= 101 && var.node_id <= 4000
    error_message = "Minimum value: `101`. Maximum value: `4000`."
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



