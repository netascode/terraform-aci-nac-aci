resource "aci_rest_managed" "ospfRtSummPol" {
  dn         = "uni/tn-${var.tenant}/ospfrtsumm-${var.name}"
  class_name = "ospfRtSummPol"
  content = {
    name             = var.name
    descr            = var.description
    cost             = var.cost
    interAreaEnabled = var.inter_area_enabled == true ? "yes" : "no"
    tag              = var.tag
    nameAlias        = var.name_alias
  }
}