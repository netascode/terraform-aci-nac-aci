resource "aci_rest_managed" "l2InstPol" {
  dn         = "uni/fabric/l2pol-${var.name}"
  class_name = "l2InstPol"
  content = {
    name      = var.name
    fabricMtu = var.port_mtu_size
  }
}