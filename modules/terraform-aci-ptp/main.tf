resource "aci_rest_managed" "latencyPtpMode" {
  dn         = "uni/fabric/ptpmode"
  class_name = "latencyPtpMode"
  content = {
    state              = var.admin_state == true ? "enabled" : "disabled"
    fabProfileTemplate = var.profile
    globalDomain       = var.global_domain
    fabAnnounceIntvl   = var.announce_interval
    fabAnnounceTimeout = var.announce_timeout
    fabSyncIntvl       = var.sync_interval
    fabDelayIntvl      = var.delay_interval
  }
}
