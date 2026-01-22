resource "aci_rest_managed" "qosPfcIfPol" {
  dn         = "uni/infra/pfc-${var.name}"
  class_name = "qosPfcIfPol"
  content = {
    name    = var.name
    descr   = var.description
    adminSt = var.admin_state
  }
}
