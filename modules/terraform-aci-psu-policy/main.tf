locals {
  admin_state = var.admin_state == "combined" ? "comb" : (var.admin_state == "nnred" ? "rdn" : (var.admin_state == "n1red" ? "ps-rdn" : ""))
}

resource "aci_rest_managed" "psuInstPol" {
  dn         = "uni/fabric/psuInstP-${var.name}"
  class_name = "psuInstPol"
  content = {
    name      = var.name
    adminRdnM = local.admin_state
  }
}
