resource "aci_rest_managed" "l3IfPol" {
  dn         = "uni/fabric/l3IfP-default"
  class_name = "l3IfPol"
  content = {
    bfdIsis = var.admin_state == true ? "enabled" : "disabled"
  }
}
