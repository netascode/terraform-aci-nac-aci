variable "pod_id" {
  description = "Pod ID. Minimum value: 1. Maximum value: 255."
  type        = number

  validation {
    condition     = var.pod_id >= 1 && var.pod_id <= 255
    error_message = "Minimum value: 1. Maximum value: 255."
  }
}

variable "tep_pool" {
  description = "TEP pool."
  type        = string
}

variable "external_tep_pools" {
  description = "List of external TEP Pools"
  type = list(object({
    prefix                 = string
    reserved_address_count = number
  }))
  default = []
}

variable "remote_pools" {
  description = "List of Remote Pools"
  type = list(object({
    id          = number
    remote_pool = string
  }))
  default = []

  validation {
    condition = alltrue([
      for r in var.remote_pools : (r.id >= 1 && r.id <= 255)
    ])
    error_message = "`id`: Minimum value: 1. Maximum value: 255."
  }
}
