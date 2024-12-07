resource "aci_rest_managed" "epLoopProtectP" {
  dn         = "uni/infra/epLoopProtectP-default"
  class_name = "epLoopProtectP"
  content = {
    action          = join(",", concat(var.bd_learn_disable ? ["bd-learn-disable"] : [], var.port_disable ? ["port-disable"] : []))
    adminSt         = var.admin_state == true ? "enabled" : "disabled"
    loopDetectIntvl = var.detection_interval
    loopDetectMult  = var.detection_multiplier
  }
}
