resource "aci_rest_managed" "vpcInstPol" {
  dn         = "uni/fabric/vpcInst-${var.name}"
  class_name = "vpcInstPol"
  content = {
    name      = var.name
    deadIntvl = var.peer_dead_interval
  }
}
