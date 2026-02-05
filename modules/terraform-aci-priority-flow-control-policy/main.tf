resource "aci_rest_managed" "qosPfcIfPol" {
  dn         = "uni/infra/pfc-${var.name}"
  class_name = "qosPfcIfPol"
  content = {
    name    = var.name
    descr   = var.description
    adminSt = var.auto_state ? "auto" : (var.admin_state ? "on" : "off")
  }
}
