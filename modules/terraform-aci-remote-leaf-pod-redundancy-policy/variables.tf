variable "enable_policy" {
  description = "Enable Remote Leaf Pod Redundancy Policy."
  type        = bool
  default     = false
}

variable "preemption" {
  description = "Enable Pod Redundancy Preemption."
  type        = bool
  default     = false
}
