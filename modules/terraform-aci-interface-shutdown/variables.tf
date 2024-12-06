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
  description = "Interface Node ID. Minimum value: `101`. Maximum value: `4000`."
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
    condition     = var.module >= 1 && var.module <= 255
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
  description = "Interface Sub-Port. Allowed values: 1-64. `0` meaning no Sub-Port."
  type        = number
  default     = 0

  validation {
    condition     = var.sub_port >= 0 && var.sub_port <= 64
    error_message = "Allowed values: 0, 1-64."
  }
}

variable "fex_id" {
  description = "Interface FEX ID. Allowed values: 101-199. `0` meaning no FEX."
  type        = number
  default     = 0

  validation {
    condition     = var.fex_id == 0 || (var.fex_id >= 101 && var.fex_id <= 199)
    error_message = "Allowed values: 0, 101-199."
  }
}
