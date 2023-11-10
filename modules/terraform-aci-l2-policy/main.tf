resource "aci_rest_managed" "l2IfPol" {
  dn         = "uni/infra/l2IfP-${var.name}"
  class_name = "l2IfPol"
  content = {
    name      = var.name
    vlanScope = var.vlan_scope
    qinq      = var.qinq
    vepa      = var.reflective_relay == true ? "enabled" : "disabled"
  }
}
