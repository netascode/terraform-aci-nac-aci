resource "aci_rest_managed" "vnsSvcEPgPol" {
  dn         = "uni/tn-${var.tenant}/svcCont/svcEPgPol-${var.name}"
  class_name = "vnsSvcEPgPol"
  content = {
    name       = var.name
    descr      = var.description
    prefGrMemb = var.preferred_group == true ? "include" : "exclude"
  }
}
