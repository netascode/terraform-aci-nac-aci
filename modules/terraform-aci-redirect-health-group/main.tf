resource "aci_rest_managed" "vnsRedirectHealthGroup" {
  dn         = "uni/tn-${var.tenant}/svcCont/redirectHealthGroup-${var.name}"
  class_name = "vnsRedirectHealthGroup"
  content = {
    name  = var.name
    descr = var.description
  }
}
