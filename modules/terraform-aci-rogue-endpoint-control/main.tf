resource "aci_rest_managed" "epControlP" {
  dn         = "uni/infra/epCtrlP-default"
  class_name = "epControlP"
  content = {
    adminSt            = var.admin_state == true ? "enabled" : "disabled"
    holdIntvl          = var.hold_interval
    rogueEpDetectIntvl = var.detection_interval
    rogueEpDetectMult  = var.detection_multiplier
  }
}
