resource "aci_rest_managed" "epLoopProtectP" {
  dn         = "uni/infra/epLoopProtectP-default"
  class_name = "epLoopProtectP"
  content = {
    action          = var.action
    adminSt         = var.admin_state == true ? "enabled" : "disabled"
    loopDetectIntvl = var.detection_interval
    loopDetectMult  = var.detection_multiplier
  }
}
