resource "aci_rest_managed" "dbgOngoingAcMode" {
  dn         = "uni/fabric/ogmode"
  class_name = "dbgOngoingAcMode"
  content = {
    name    = "default"
    adminSt = var.admin_state ? "enabled" : "disabled"
    mode    = var.mode
  }
}
