resource "aci_rest_managed" "ptpProfile" {
  dn         = "uni/infra/ptpprofile-${var.name}"
  class_name = "ptpProfile"
  content = {
    name                 = var.name
    announceIntvl        = var.announce_interval
    announceTimeout      = var.announce_timeout
    delayIntvl           = var.delay_interval
    profileTemplate      = var.template == "telecom" ? "telecom_full_path" : var.template == "smpte" ? "smpte" : "aes67"
    ptpoeDstMacRxNoMatch = var.mismatch_handling == "configured" ? "replyWithCfgMac" : var.mismatch_handling == "received" ? "replyWithRxMac" : "drop"
    ptpoeDstMacType      = var.forwardable ? "forwardable" : "non-forwardable"
    syncIntvl            = var.sync_interval
    localPriority        = var.priority
  }
}