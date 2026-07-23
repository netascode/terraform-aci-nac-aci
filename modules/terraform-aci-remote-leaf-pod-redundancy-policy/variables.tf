variable "enable_remote_leaf_policy" {
  description = "Enable Remote Leaf Pod Redundancy Policy."
  type        = bool
  default     = false
}

variable "enable_preemption" {
  description = "Enable Pod Redundancy Preemption."
  type        = bool
  default     = false
}
