resource "aci_rest_managed" "l2InstPol" {
  dn         = "uni/fabric/l2pol-default"
  class_name = "l2InstPol"
  content = {
    name      = "default"
    fabricMtu = var.l2_port_mtu
  }
}
