resource "aci_rest_managed" "infraPortTrackPol" {
  dn         = "uni/infra/trackEqptFabP-default"
  class_name = "infraPortTrackPol"
  content = {
    adminSt  = var.admin_state == true ? "on" : "off"
    delay    = var.delay
    minlinks = var.min_links
  }
}
