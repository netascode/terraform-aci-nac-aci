variable "preserve_cos" {
  description = "Preserve CoS."
  type        = bool
  default     = false
}

variable "qos_classes" {
  description = "List of QoS classes. Allowed values `level`: 1-6. Default value `admin_state`: true. Allowed values `mtu`: 1-9216. Default value `mtu`: 9000. Allowed values `bandwidth_percent`: 0-100. Default value `bandwidth_percent`: 20. Choices `scheduling`: `wrr`, `strict-priority`. Default value `scheduling`: `wrr`. Choices `congestion_algorithm`: `tail-drop`, `wred`. Default value `congestion_algorithm`: `tail-drop`. Allowed values `minimum_buffer`: 0-3. Default value `minimum_buffer`: 0. Default value `pfc_state`: false. Choices `no_drop_cos`: `unspecified`, `cos0`, `cos1`, `cos2`, `cos3`, `cos4`, `cos5`, `cos6`, `cos7`, ``. Default value `no_drop_cos`: ``. Choices `pfc_scope`: `tor`, `fabric`. Default value `pfc_scope`: `tor`. Default value `ecn`: false. Default value `forward_non_ecn`: false. Allowed values `wred_max_threshold`: 0-100. Default value `wred_max_threshold`: 100. Allowed values `wred_min_threshold`: 0-100. Default value `wred_min_threshold`: 0. Allowed values `wred_probability`: 0-100. Default value `wred_probability`: 0. Allowed values `weight`: 0-7. Default value `weight`: 0."
  type = list(object({
    level                = number
    admin_state          = optional(bool, true)
    mtu                  = optional(number, 9000)
    scheduling           = optional(string, "wrr")
    bandwidth_percent    = optional(number, 20)
    congestion_algorithm = optional(string, "tail-drop")
    minimum_buffer       = optional(number, 0)
    pfc_state            = optional(bool, false)
    no_drop_cos          = optional(string, "")
    pfc_scope            = optional(string, "tor")
    ecn                  = optional(bool, false)
    forward_non_ecn      = optional(bool, false)
    wred_max_threshold   = optional(number, 100)
    wred_min_threshold   = optional(number, 0)
    wred_probability     = optional(number, 0)
    weight               = optional(number, 0)
  }))
  default = []

  validation {
    condition = alltrue(
      [for class in var.qos_classes : (class.level >= 1 && class.level <= 6)]
    )
    error_message = "`level`: Minimum value: 1. Maximum value: 6."
  }

  validation {
    condition = alltrue(
      [for class in var.qos_classes : class.mtu == null || (class.mtu >= 1 && class.mtu <= 9216)]
    )
    error_message = "`mtu`: Minimum value: 1. Maximum value: 9216."
  }

  validation {
    condition = alltrue(
      [for class in var.qos_classes : class.bandwidth_percent == null || (class.bandwidth_percent >= 0 && class.bandwidth_percent <= 100)]
    )
    error_message = "`bandwidth_percent`: Minimum value: 0. Maximum value: 100."
  }

  validation {
    condition = alltrue(
      [for class in var.qos_classes : class.scheduling == null || try(contains(["wrr", "strict-priority"], class.scheduling), false)]
    )
    error_message = "`scheduling`: Allowed values are `wrr` or `strict-priority`."
  }

  validation {
    condition = alltrue(
      [for class in var.qos_classes : class.congestion_algorithm == null || try(contains(["tail-drop", "wred"], class.congestion_algorithm), false)]
    )
    error_message = "`congestion_algorithm`: Allowed values are `tail-drop` or `wred`."
  }

  validation {
    condition = alltrue(
      [for class in var.qos_classes : class.minimum_buffer == null || (class.minimum_buffer >= 0 && class.minimum_buffer <= 3)]
    )
    error_message = "`minimum_buffer`: Minimum value: 0. Maximum value: 3."
  }

  validation {
    condition = alltrue(
      [for class in var.qos_classes : class.no_drop_cos == null || try(contains(["unspecified", "cos0", "cos1", "cos2", "cos3", "cos4", "cos5", "cos6", "cos7", ""], class.no_drop_cos), false)]
    )
    error_message = "`no_drop_cos`: Allowed values are `unspecified`, `cos0`, `cos1`, `cos2`, `cos3`, `cos4`, `cos5`, `cos6`, `cos7` or ``."
  }

  validation {
    condition = alltrue(
      [for class in var.qos_classes : class.pfc_scope == null || try(contains(["tor", "fabric"], class.pfc_scope), false)]
    )
    error_message = "`pfc_scope`: Allowed values are `tor` or `fabric`."
  }

  validation {
    condition = alltrue(
      [for class in var.qos_classes : class.wred_max_threshold == null || (class.wred_max_threshold >= 0 && class.wred_max_threshold <= 100)]
    )
    error_message = "`wred_max_threshold`: Minimum value: 0. Maximum value: 100."
  }

  validation {
    condition = alltrue(
      [for class in var.qos_classes : class.wred_min_threshold == null || (class.wred_min_threshold >= 0 && class.wred_min_threshold <= 100)]
    )
    error_message = "`wred_min_threshold`: Minimum value: 0. Maximum value: 100."
  }

  validation {
    condition = alltrue(
      [for class in var.qos_classes : class.wred_probability == null || (class.wred_probability >= 0 && class.wred_probability <= 100)]
    )
    error_message = "`wred_probability`: Minimum value: 0. Maximum value: 100."
  }

  validation {
    condition = alltrue(
      [for class in var.qos_classes : class.weight == null || (class.weight >= 0 && class.weight <= 7)]
    )
    error_message = "`weight`: Minimum value: 0. Maximum value: 7."
  }
}
