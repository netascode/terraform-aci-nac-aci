resource "aci_rest_managed" "epIpAgingP" {
  dn         = "uni/infra/ipAgingP-default"
  class_name = "epIpAgingP"
  content = {
    adminSt = var.admin_state == true ? "enabled" : "disabled"
  }
}
