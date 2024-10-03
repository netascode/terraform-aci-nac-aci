variable "sr_global_block_minimum" {
  description = "SR Global Block Minimum. Minimum value: 16000. Maximum value: 471804."
  type        = number

  validation {
    condition     = var.sr_global_block_minimum >= 16000 && var.sr_global_block_minimum <= 471804
    error_message = "Minimum value: 16000. Maximum value: 471804."
  }
}

variable "sr_global_block_maximum" {
  description = "SR Global Block Maximum. Minimum value: 16000. Maximum value: 471804."
  type        = number

  validation {
    condition     = var.sr_global_block_maximum >= 16000 && var.sr_global_block_maximum <= 471804
    error_message = "Minimum value: 16000. Maximum value: 471804."
  }
}
