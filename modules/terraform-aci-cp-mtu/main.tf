resource "aci_rest_managed" "cpMtuPolicy" {
  dn         = "uni/infra/ifpol-${var.name}"
  class_name = "infraCPMtuPol"

  content = {
    name  = var.name
    descr = var.description
    mtu   = var.cp_mtu
  }
}
