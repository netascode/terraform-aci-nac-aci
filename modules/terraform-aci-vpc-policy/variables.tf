variable "name" {
  description = "VPC policy name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.name))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "peer_dead_interval" {
  description = "Peer dead interval. Minimum value: 5. Maximum value: 600."
  type        = number
  default     = 200

  validation {
    condition     = var.peer_dead_interval >= 5 && var.peer_dead_interval <= 600
    error_message = "Minimum value: 5. Maximum value: 600."
  }
}

variable "delay_restore_timer" {
  description = "Delay restore timer. Minimum value: 120. Maximum value: 600."
  type        = number
  default     = null

  validation {
    condition     = var.delay_restore_timer == null ? true : var.delay_restore_timer >= 120 && var.delay_restore_timer <= 600
    error_message = "Minimum value: 120. Maximum value: 600."
  }
}
