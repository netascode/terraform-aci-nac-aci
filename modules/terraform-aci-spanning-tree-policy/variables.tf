variable "name" {
  description = "Spanning tree policy name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.name))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "bpdu_filter" {
  description = "BPDU filter."
  type        = bool
  default     = false
}

variable "bpdu_guard" {
  description = "BPDU guard."
  type        = bool
  default     = false
}
